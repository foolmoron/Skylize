Tile = IgeEntity.extend
    classId: 'Tile'
    
    init: (@_size) ->
        IgeEntity::init.call @
        
        @_lights = {}
        @_lights.l = new Light(Light.TYPE.SIDE)
            .translateTo -@_size/2, 0, 0
            .color Light.COLOR.WHITE
            .depth 0
            .mount @
        @_lights.t = new Light(Light.TYPE.SIDE)
            .rotateTo 0, 0, 1.57
            .translateTo 0, -@_size/2, 0
            .color Light.COLOR.RED
            .depth 0
            .mount @
        @_lights.f = new Light(Light.TYPE.DIAG)
            .color Light.COLOR.BLUE
            .depth 1
            .mount @
        @_lights.b = new Light(Light.TYPE.DIAG)
            .rotateTo 0, 0, 1.57
            .color Light.COLOR.GREEN
            .depth 1
            .mount @
        @_lights.v = new Light(Light.TYPE.MID)
            .color Light.COLOR.PINK
            .depth 2
            .mount @
        @_lights.h = new Light(Light.TYPE.MID)
            .rotateTo 0, 0, 1.57
            .color Light.COLOR.YELLOW
            .depth 2
            .mount @

module.exports = Tile if module?.exports?