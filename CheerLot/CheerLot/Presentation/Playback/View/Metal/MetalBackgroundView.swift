// MetalBackgroundView.swift
import SwiftUI
import MetalKit

// MARK: - Uniforms (must match Shaders.metal)
struct Uniforms {
    var time: Float
    var resolution: SIMD2<Float>
}

// MARK: - Metal Renderer
final class MetalRenderer: NSObject, MTKViewDelegate {

    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState
    private var uniformBuffer: MTLBuffer

    private var startDate = Date()

    init?(mtkView: MTKView) {
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
        else { return nil }

        self.device = device
        self.commandQueue = commandQueue
        mtkView.device = device
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.framebufferOnly = false
        mtkView.isOpaque = false

        // Load shaders from the default library
        guard let library = device.makeDefaultLibrary(),
              let vertFn = library.makeFunction(name: "vertex_main"),
              let fragFn = library.makeFunction(name: "fragment_main") else {
            return nil
        }

        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertFn
        descriptor.fragmentFunction = fragFn
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

        // Alpha blending: src=One (premultiplied), dst=OneMinusSrcAlpha
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].alphaBlendOperation = .add
        descriptor.colorAttachments[0].sourceRGBBlendFactor = .one
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        descriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha

        guard let pipeline = try? device.makeRenderPipelineState(descriptor: descriptor) else {
            return nil
        }
        self.pipelineState = pipeline

        var initial = Uniforms(time: 0, resolution: SIMD2<Float>(1, 1))
        guard let buf = device.makeBuffer(bytes: &initial,
                                          length: MemoryLayout<Uniforms>.stride,
                                          options: .storageModeShared) else { return nil }
        self.uniformBuffer = buf

        super.init()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        guard
            let drawable  = view.currentDrawable,
            let rpd       = view.currentRenderPassDescriptor,
            let cmdBuf    = commandQueue.makeCommandBuffer(),
            let encoder   = cmdBuf.makeRenderCommandEncoder(descriptor: rpd)
        else { return }

        let elapsed = Float(Date().timeIntervalSince(startDate))
        let size    = view.drawableSize

        var uniforms = Uniforms(
            time:       elapsed,
            resolution: SIMD2<Float>(Float(size.width), Float(size.height))
        )
        memcpy(uniformBuffer.contents(), &uniforms, MemoryLayout<Uniforms>.stride)

        encoder.setRenderPipelineState(pipelineState)
        encoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 0)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        encoder.endEncoding()

        cmdBuf.present(drawable)
        cmdBuf.commit()
    }
}

// MARK: - UIViewRepresentable
struct MetalBackgroundView: UIViewRepresentable {

    func makeCoordinator() -> MetalRenderer? {
        let view = MTKView()
        return MetalRenderer(mtkView: view)
    }

    func makeUIView(context: Context) -> MTKView {
        let view = MTKView()
        view.preferredFramesPerSecond = 60
        view.enableSetNeedsDisplay = false
        view.isPaused = false
        view.isOpaque = false
        view.backgroundColor = .clear
        if let renderer = MetalRenderer(mtkView: view) {
            view.delegate = renderer
            // Keep renderer alive via objc association
            objc_setAssociatedObject(view, &AssociatedKey.renderer, renderer, .OBJC_ASSOCIATION_RETAIN)
        }
        return view
    }

    func updateUIView(_ uiView: MTKView, context: Context) {}
}

private enum AssociatedKey {
    static var renderer = "renderer"
}
