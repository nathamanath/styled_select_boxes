module.exports  = ( grunt ) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      build:
        src:  'build/<%= pkg.name %>.js',
        dest: 'build/<%= pkg.name %>.min.js'

    coffee:
      compile:
        files:
          'build/<%= pkg.name %>.js': ['src/*.coffee'],

    coffeelint:
      app: 'src/*.coffee'

    coffee_jshint:
      options: []
      source:
        src: 'src/*.coffee'

    sass:
      dist:
        files: ['example/main.css': 'src/*.sass']

    watch:
      scripts:
        files: [
          'src/*.coffee',
        ]
        tasks: [
          'compile',
          'inspection'
        ]

  # Load plugins
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-coffee-jshint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-sass'

  grunt.registerTask 'default', [
    'compile',
    'inspection'
  ]

  grunt.registerTask 'compile', [
    'coffee',
    'uglify',
    'sass'
  ]

  grunt.registerTask 'inspection', [
    'coffeelint',
    'coffee_jshint'
  ]

