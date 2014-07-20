Codo        = require 'codo'
CodoCommand = require 'codo/lib/command'
gutil       = require 'gulp-util'

class CodoHelper extends CodoCommand

  DEFAULT_OPTIONS =
    src: './app/scripts'
    theme: 'default'
    output: './documentation'

  constructor: (options = {}) ->
    @options = DEFAULT_OPTIONS
    for key, value of options
      @options[key] = value
    @lookupTheme(@options.theme)
    @generateSrc()

  generateSrc: ->
    console.log @options
    environment = Codo.parseProject(@options.src)
    sections    = @collectStats(environment)
    @theme.compile(environment)

    # overall      = 0
    # undocumented = 0

    # for section, data of sections
    #   overall      += data.total
    #   undocumented += data.undocumented.length

    # console.log ''
    gutil.log "Codo documentation generated from '#{@options.src}' to '#{@options.output}'."
    # console.log ''
    # console.log "    Total files   #{environment.allFiles().length}"
    # console.log "    Total extras  #{environment.allExtras().length}"
    # console.log "    Classes       #{sections['Classes'].total} (#{sections['Classes'].undocumented.length} undocumented)"
    # console.log "    Mixins        #{sections['Mixins'].total} (#{sections['Mixins'].undocumented.length} undocumented)"
    # console.log "    Methods       #{sections['Methods'].total} (#{sections['Methods'].undocumented.length} undocumented)"
    # console.log ''
    # console.log "  Totally documented: #{(100 - 100/overall*undocumented).toFixed(2)}%"
    # console.log ''

module.exports = (options) -> new CodoHelper(options)