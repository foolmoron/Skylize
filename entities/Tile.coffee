Tile = IgeEntity.extend
    classId: 'Tile'
    
    init: (@_size) ->
        IgeEntity::init.call @
        @_l = new IgeEntity()
            .texture SL.tex['side']
            .dimensionsFromCell()
            .translateTo -@_size/2, 0, 0
            .mount @
        @_t = new IgeEntity()
            .texture SL.tex['side']
            .dimensionsFromCell()
            .rotateTo 0, 0, 1.57
            .translateTo 0, -@_size/2, 0
            .mount @

module.exports = Tile if module?.exports?