Light = IgeEntity.extend
    classId: 'Light'
    
    init: (@_type) ->
        IgeEntity::init.call @
        
        @color(Light.COLOR.WHITE).dimensionsFromCell()

    color: (color) ->
        if color == undefined
            return @_color

        @_color = color
        if color == Light.COLOR.NONE
            @texture(null)
        else
            @texture(SL.tex[@_type + @_color])
        return @

Light.TYPE = { SIDE: 'side', DIAG: 'diag', MID: 'mid'}
Light.COLOR = { NONE: 'none', WHITE: 'w', RED: 'r', GREEN: 'g', BLUE: 'b', PINK: 'p', YELLOW: 'y'}

module.exports = Light if module?.exports?