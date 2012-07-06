class Walker
  constructor: ->
    @mvMatrixStack = []
    @mvMatrix = Matrix.I(4);

    @zoom = -5;
    @rotation = 45
    @currentlyPressedKeys = []
    @currentTime = (new Date).getTime()

    document.onkeyup   = @handleKeyUp;
    document.onkeydown = @handleKeyDown;

    @models = []
    @models[0] = new window.cube
    # @models[1] = new window.pillar

    if gl
      gl.clearColor(0.0, 0.0, 0.0, 1.0);  # Clear to black, fully opaque
      gl.clearDepth(1.0);                 # Clear everything
      gl.enable(gl.DEPTH_TEST);           # Enable depth testing
      gl.depthFunc(gl.LEQUAL);            # Near things obscure far things

      gl.initShaders();

      # @initBuffers(gl)
      @models[0].buffer()
      # @models[1].buffer()

      setInterval(@drawLoop, 15, gl, @);

  drawLoop: (gl, scope) ->
    scope.drawScene(gl)

  handleKeyDown: (event) ->
    window.walker.currentlyPressedKeys[event.keyCode] = true

  handleKeyUp: (event) ->
    window.walker.currentlyPressedKeys[event.keyCode] = false

  handleKeys: ->
    if (@currentlyPressedKeys[37])
      @rotation -= 360*@dt();
    if (@currentlyPressedKeys[39])
      @rotation += 360*@dt();

    if (@currentlyPressedKeys[187])
      @zoom *= 0.9;
    if (@currentlyPressedKeys[189])
      @zoom *= 1.1;

  dt: ->
    return (((new Date).getTime() - @currentTime) / 1000);


  drawScene:(gl,scope) ->
    # this = scope
    @handleKeys();

    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    gl.perspectiveMatrix = makePerspective(45, 640.0/480.0, 0.1, 100.0);

    gl.loadIdentity();

    gl.mvTranslate([-0.0, 0.0, @zoom]);
    gl.mvRotate(45, [1, 0, 0]);
    gl.mvRotate(@rotation, [0, 1, 0]);

    gl.mvPushMatrix();
    # @drawCube(gl);
    @models[0].draw()
    gl.mvPopMatrix();

    # gl.mvPushMatrix();
    # # @drawCube(gl);
    # @models[1].draw()
    # gl.mvPopMatrix();

    @currentTime = (new Date).getTime();

window.walker_object = Walker

