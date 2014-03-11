Light = IgeEntity.extend
    classId: 'Light'
    
    init: (@_type) ->
        IgeEntity::init.call @
        
        @color(Light.COLOR.WHITE).dimensionsFromCell()

    color: (color) ->
        if color == undefined
            return @_color

        @_color = color
        @texture(SL.tex[@_type + @_color])
        return @

Light.TYPE = { SIDE: 'side', DIAG: 'diag', MID: 'mid'}
Light.COLOR = { WHITE: 'w', RED: 'r', GREEN: 'g', BLUE: 'b', PINK: 'p', YELLOW: 'y'}

module.exports = Light if module?.exports?