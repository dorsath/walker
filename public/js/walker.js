// Generated by CoffeeScript 1.3.3
(function() {
  var Walker;

  this.start = function() {
    return window.walker = new Walker;
  };

  Walker = (function() {

    function Walker() {
      var canvas, gl;
      this.mvMatrixStack = [];
      this.mvMatrix = Matrix.I(4);
      this.zoom = -5;
      this.rotation = 45;
      this.currentlyPressedKeys = [];
      this.currentTime = (new Date).getTime();
      canvas = document.getElementById("glcanvas");
      document.onkeyup = this.handleKeyUp;
      document.onkeydown = this.handleKeyDown;
      gl = canvas.getContext("experimental-webgl");
      if (gl) {
        gl.clearColor(0.0, 0.0, 0.0, 1.0);
        gl.clearDepth(1.0);
        gl.enable(gl.DEPTH_TEST);
        gl.depthFunc(gl.LEQUAL);
        this.initShaders(gl);
        this.initBuffers(gl);
        setInterval(this.drawLoop, 15, gl, this);
      }
    }

    Walker.prototype.drawLoop = function(gl, scope) {
      return scope.drawScene(gl);
    };

    Walker.prototype.handleKeyDown = function(event) {
      return walker.currentlyPressedKeys[event.keyCode] = true;
    };

    Walker.prototype.handleKeyUp = function(event) {
      return walker.currentlyPressedKeys[event.keyCode] = false;
    };

    Walker.prototype.handleKeys = function() {
      if (this.currentlyPressedKeys[37]) {
        this.rotation -= 360 * this.dt();
      }
      if (this.currentlyPressedKeys[39]) {
        this.rotation += 360 * this.dt();
      }
      if (this.currentlyPressedKeys[187]) {
        this.zoom *= 0.9;
      }
      if (this.currentlyPressedKeys[189]) {
        return this.zoom *= 1.1;
      }
    };

    Walker.prototype.initBuffers = function(gl) {
      var cubeVertexIndices, generatedColors, vertices;
      this.cubeVerticesBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, this.cubeVerticesBuffer);
      vertices = [-1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0, -1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0, -1.0, -1.0];
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
      generatedColors = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1];
      this.cubeVerticesColorBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, this.cubeVerticesColorBuffer);
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(generatedColors), gl.STATIC_DRAW);
      this.cubeVerticesIndexBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.cubeVerticesIndexBuffer);
      cubeVertexIndices = [0, 3, 4, 4, 5, 3, 1, 2, 6, 6, 7, 1, 0, 1, 2, 2, 3, 0, 4, 5, 6, 6, 7, 4, 0, 1, 4, 7, 4, 1, 2, 3, 5, 5, 6, 2];
      return gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(cubeVertexIndices), gl.STATIC_DRAW);
    };

    Walker.prototype.dt = function() {
      return ((new Date).getTime() - this.currentTime) / 1000;
    };

    Walker.prototype.drawScene = function(gl, scope) {
      this.handleKeys();
      gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
      this.perspectiveMatrix = makePerspective(45, 640.0 / 480.0, 0.1, 100.0);
      this.loadIdentity();
      this.mvTranslate([-0.0, 0.0, this.zoom]);
      this.mvRotate(45, [1, 0, 0]);
      this.mvRotate(this.rotation, [0, 1, 0]);
      this.mvPushMatrix();
      this.drawCube(gl);
      this.mvPopMatrix();
      return this.currentTime = (new Date).getTime();
    };

    Walker.prototype.drawCube = function(gl) {
      gl.bindBuffer(gl.ARRAY_BUFFER, this.cubeVerticesBuffer);
      gl.vertexAttribPointer(this.vertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);
      gl.bindBuffer(gl.ARRAY_BUFFER, this.cubeVerticesColorBuffer);
      gl.vertexAttribPointer(this.vertexColorAttribute, 4, gl.FLOAT, false, 0, 0);
      gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.cubeVerticesIndexBuffer);
      this.setMatrixUniforms(gl);
      return gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0);
    };

    Walker.prototype.initShaders = function(gl) {
      var fragmentShader, vertexColorAttribute, vertexShader;
      fragmentShader = this.getShader(gl, "shader-fs");
      vertexShader = this.getShader(gl, "shader-vs");
      this.shaderProgram = gl.createProgram();
      gl.attachShader(this.shaderProgram, vertexShader);
      gl.attachShader(this.shaderProgram, fragmentShader);
      gl.linkProgram(this.shaderProgram);
      if (!gl.getProgramParameter(this.shaderProgram, gl.LINK_STATUS)) {
        alert("Unable to initialize the shader program.");
      }
      gl.useProgram(this.shaderProgram);
      this.vertexPositionAttribute = gl.getAttribLocation(this.shaderProgram, "aVertexPosition");
      gl.enableVertexAttribArray(this.vertexPositionAttribute);
      vertexColorAttribute = gl.getAttribLocation(this.shaderProgram, "aVertexColor");
      return gl.enableVertexAttribArray(vertexColorAttribute);
    };

    Walker.prototype.getShader = function(gl, id) {
      var currentChild, shader, shaderScript, theSource;
      shaderScript = document.getElementById(id);
      if (!shaderScript) {
        return null;
      }
      theSource = "";
      currentChild = shaderScript.firstChild;
      while (currentChild) {
        if (currentChild.nodeType === 3) {
          theSource += currentChild.textContent;
        }
        currentChild = currentChild.nextSibling;
      }
      if (shaderScript.type === "x-shader/x-fragment") {
        shader = gl.createShader(gl.FRAGMENT_SHADER);
      } else if (shaderScript.type === "x-shader/x-vertex") {
        shader = gl.createShader(gl.VERTEX_SHADER);
      } else {
        return;
      }
      gl.shaderSource(shader, theSource);
      gl.compileShader(shader);
      if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
        alert("An error occurred compiling the shaders: " + gl.getShaderInfoLog(shader));
        return null;
      }
      return shader;
    };

    Walker.prototype.loadIdentity = function() {
      return this.mvMatrix = Matrix.I(4);
    };

    Walker.prototype.multMatrix = function(m) {
      return this.mvMatrix = this.mvMatrix.x(m);
    };

    Walker.prototype.mvTranslate = function(v) {
      return this.multMatrix(Matrix.Translation($V([v[0], v[1], v[2]])).ensure4x4());
    };

    Walker.prototype.setMatrixUniforms = function(gl) {
      var mvUniform, pUniform;
      pUniform = gl.getUniformLocation(this.shaderProgram, "uPMatrix");
      gl.uniformMatrix4fv(pUniform, false, new Float32Array(this.perspectiveMatrix.flatten()));
      mvUniform = gl.getUniformLocation(this.shaderProgram, "uMVMatrix");
      return gl.uniformMatrix4fv(mvUniform, false, new Float32Array(this.mvMatrix.flatten()));
    };

    Walker.prototype.mvPushMatrix = function(m) {
      if (m) {
        this.mvMatrixStack.push(m.dup());
        return this.mvMatrix = m.dup();
      } else {
        return this.mvMatrixStack.push(this.mvMatrix.dup());
      }
    };

    Walker.prototype.mvPopMatrix = function() {
      if (!this.mvMatrixStack.length) {
        throw "Can't pop from an empty matrix stack.";
      }
      this.mvMatrix = this.mvMatrixStack.pop();
      return this.mvMatrix;
    };

    Walker.prototype.mvRotate = function(angle, v) {
      var inRadians, m;
      inRadians = angle * Math.PI / 180.0;
      m = Matrix.Rotation(inRadians, $V([v[0], v[1], v[2]])).ensure4x4();
      return this.multMatrix(m);
    };

    return Walker;

  })();

}).call(this);