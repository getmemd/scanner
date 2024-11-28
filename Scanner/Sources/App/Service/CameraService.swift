//
//  CameraService.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 01.11.2024.
//

import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

enum FilterType: String, CaseIterable {
    case red, green, blue, blackWhite
}

enum CameraAuthorizationError: Error, LocalizedError {
    case accessDenied
    case restricted
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Access to the camera has been denied. Please enable it in Settings."
        case .restricted:
            return "Access to the camera is restricted and cannot be enabled."
        case .unknown:
            return "An unknown error occurred while checking camera authorization."
        }
    }
}

final class CameraService: NSObject {
    private let captureSession = AVCaptureSession()
    private var videoOutput: AVCaptureVideoDataOutput?
    private var captureDevice: AVCaptureDevice?
    private var addToPreviewStream: ((CIImage) -> Void)?
    private let context = CIContext()
    private var currentFilter: CIFilter?
    var isPreviewPaused = false
    
    lazy var previewStream: AsyncStream<CIImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { ciImage in
                if !self.isPreviewPaused {
                    continuation.yield(ciImage)
                }
            }
        }
    }()
    
    private func setupCamera() {
        captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let captureDevice = captureDevice, let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Failed to obtain video input.")
            return
        }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput?.alwaysDiscardsLateVideoFrames = true
        videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoDataOutputQueue"))
        
        guard captureSession.canAddInput(deviceInput), captureSession.canAddOutput(videoOutput!) else {
            print("Unable to add input or output to capture session.")
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput!)
        
        if let connection = videoOutput?.connection(with: .video) {
            connection.videoOrientation = .portrait
        }
    }
    
    private func checkAuthorization() async throws {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if !granted {
                throw CameraAuthorizationError.accessDenied
            }
        case .denied:
            throw CameraAuthorizationError.accessDenied
        case .restricted:
            throw CameraAuthorizationError.restricted
        @unknown default:
            throw CameraAuthorizationError.unknown
        }
    }
    
    func start() async throws {
        try await checkAuthorization()
        setupCamera()
        setFilter(.red)
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    func stop() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func setFilter(_ filterType: FilterType) {
        switch filterType {
        case .red:
            let filter = CIFilter.colorMatrix()
            filter.setValue(CIVector(x: 1, y: 0, z: 0, w: 0), forKey: "inputRVector")
            filter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputGVector")
            filter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBVector")
            currentFilter = filter
        case .green:
            let filter = CIFilter.colorMatrix()
            filter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputRVector")
            filter.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputGVector")
            filter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBVector")
            currentFilter = filter
        case .blue:
            let filter = CIFilter.colorMatrix()
            filter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputRVector")
            filter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputGVector")
            filter.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputBVector")
            currentFilter = filter
        case .blackWhite:
            let filter = CIFilter.colorMonochrome()
            filter.setValue(CIColor.white, forKey: "inputColor")
            filter.setValue(1.0, forKey: "inputIntensity")
            currentFilter = filter
        }
    }
}

extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
        var ciImage = CIImage(cvPixelBuffer: pixelBuffer).oriented(.up)
        if let filter = currentFilter {
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            ciImage = filter.outputImage ?? ciImage
        }
        addToPreviewStream?(ciImage)
    }
}
