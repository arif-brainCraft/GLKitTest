//
//  ViewController.swift
//  GLKitTest
//
//  Created by BCL Device7 on 15/9/22.
//

import UIKit
import GLKit

class MyViewController: GLKViewController {

    @IBOutlet weak var glkView : GLKView!
    
    private var context : EAGLContext?
    private var rotation:Float = 0.0
    
    var vertices = [
        Vertex(x:  1, y: -1, z: 0, r: 1, g: 0, b: 0, a: 1),
        Vertex(x:  1, y:  1, z: 0, r: 0, g: 1, b: 0, a: 1),
        Vertex(x: -1, y:  1, z: 0, r: 0, g: 0, b: 1, a: 1),
        Vertex(x: -1, y: -1, z: 0, r: 0, g: 0, b: 0, a: 1)
    ]
    
    var indices:[GLubyte] = [
        0,1,2,
        2,3,0
    ]
    
    var ebo = GLuint()
    var vbo = GLuint()
    var vao = GLuint()
    
    private var effect = GLKBaseEffect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGl()
    }

    func setupGl() {
        context = EAGLContext(api: .openGLES3)
        EAGLContext.setCurrent(context)
        
        if  let view = self.view as? GLKView, let context = context {
            view.context = context
            delegate = self
        }
        
        let vertexAttribColor = GLuint(GLKVertexAttrib.color.rawValue)
        let vertexAttribPos = GLuint(GLKVertexAttrib.position.rawValue)
        
        let vertexSize = MemoryLayout<Vertex>.stride
        let colorOffset = MemoryLayout<GLfloat>.stride * 3
        
        let colorOffsetPointer = UnsafeRawPointer(bitPattern: colorOffset)
        
        glGenVertexArraysOES(1, &vao)
        glBindVertexArrayOES(vao)
        
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertices.size(), vertices, GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(vertexAttribPos)
        glVertexAttribPointer(vertexAttribPos, 3, GLenum(GL_FLOAT), GLboolean(UInt8(GL_FALSE)), GLsizei(vertexSize), nil)
        
        
        glEnableVertexAttribArray(vertexAttribColor)
        glVertexAttribPointer(vertexAttribColor, 4, GLenum(GL_FLOAT), GLboolean(UInt8(GL_FALSE)), GLsizei(vertexSize), colorOffsetPointer)
        
        glGenBuffers(1, &ebo)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), ebo)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.size(), indices, GLenum(GL_STATIC_DRAW))
        
        
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
        
    }
    
    func release() {
        EAGLContext.setCurrent(context)
        glDeleteBuffers(1, &vao)
        glDeleteBuffers(1, &vbo)
        glDeleteBuffers(1, &ebo)
        
        EAGLContext.setCurrent(nil)
        context = nil
    }
    
    deinit {
        release()
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        print("glkview draw method called")
        glClearColor(0.85, 0.85, 0.85, 0.85)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        effect.prepareToDraw()
        
        glBindVertexArrayOES(vao)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        glBindVertexArrayOES(0)
        
    }
    
}

extension MyViewController: GLKViewControllerDelegate{
    
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        
        let aspect = fabsf(Float(self.view.bounds.size.width / self.view.bounds.size.height))
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 4.0, 10.0)
        effect.transform.projectionMatrix = projectionMatrix
        
        
        var modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -10.0)
        
        rotation += 90 * Float(timeSinceLastUpdate)
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(rotation), 0, 0, 1)
        effect.transform.modelviewMatrix = modelViewMatrix
        
    }
    
    
}
