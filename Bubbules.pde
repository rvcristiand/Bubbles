/**
 * Bubbles
 * by Cristian Ramirez
 */

import frames.core.Graph;

import frames.primitives.Vector;
import frames.primitives.Quaternion;

import frames.processing.Scene;
import frames.processing.Shape;

Scene scene;

Bubble[] bubbles;

Vector p1;

void setup() {
  size(800, 600, P3D);
  scene = new Scene(this);
  scene.setRightHanded();
  scene.setType(Graph.Type.ORTHOGRAPHIC);
  
  bubbles = new Bubble[10];
  
  for (int i = 0; i < bubbles.length; i++) {
    p1 = Vector.random();
    p1.setMagnitude(scene.radius() / 3);
    
    bubbles[i] = new Bubble(scene, p1, String.valueOf(i));
  }
  println("One Click: cast\n" +
          "Two Clicks: tongle left/right handed scene" +
          "Drag with Left Button: translate scene\n" + 
          "Drag with Right Button: rotate the scene\n" + 
          "Wheel Button: scale the scene");
}

void pre() {
  background(0);
}


void draw() {
  background(0);
  scene.traverse();
  scene.drawAxes();
}

class Bubble {
  Scene _scene;
    
  Vector _p1;
  
  String _label;
  
  Shape shape;
  
  public Bubble(Scene scene, Vector p1, String label) {
    _scene = scene;
    
    _p1 = p1;
    
    _label = label;
    
    shape = new Shape(_scene) {
      @Override
      void setGraphics(PGraphics pGraphics) {
        // set shape's position, orientation and highlighting
        setPosition(_p1);
        // setOrientation(new Quaternion(new Vector(1, 0, 0), _p1));
        setHighlighting(Shape.Highlighting.NONE);
        
        // set color
        int red = 239;
        int green = 127;
        int blue = 26;
        
        float r = _scene.radius() / 25;
        
        pGraphics.pushStyle();
        
        pGraphics.strokeWeight(3);
        
        pGraphics.stroke(color(isTracked() ? 255 - red : red,
                               isTracked() ? 255 - green : green,
                               isTracked() ? 255 - blue : blue));
        
        // bubble
        pGraphics.fill(color(isTracked() ? 255 - red : red,
                             isTracked() ? 255 - green : green,
                             isTracked() ? 255 - blue : blue), 
                             127);
        pGraphics.ellipse(0, 0, 2*r, 2*r);
        
        pGraphics.popStyle();
        
        pGraphics.pushStyle();
        pGraphics.textMode(SHAPE);
        pGraphics.textAlign(CENTER, CENTER);
        pGraphics.fill(0);
        pGraphics.textSize(r);
        pGraphics.hint(DISABLE_DEPTH_TEST);
        pGraphics.text(_label, 0, 0);
        pGraphics.popStyle();
        
        Scene.drawAxes(pGraphics, 4 * r, false);
      }
    };
  }
}

void mouseClicked(MouseEvent event) {
  if (event.getCount() == 1) {
    scene.cast();
  } else if (event.getCount() == 2) {
    if (scene.isRightHanded()) {
      scene.setLeftHanded();
    }
    else {
      scene.setRightHanded();
    }
  }
}

void mouseDragged(MouseEvent event) {
  if (event.getButton() == RIGHT) {
    scene.spin();// scene.rotateCAD(new Vector(0, 0, 1));
  }
  if (event.getButton() == LEFT) {
    scene.translate();
  }
}

void mouseWheel(MouseEvent event) {
  scene.scale(-100 * event.getCount(), scene.eye());
}
