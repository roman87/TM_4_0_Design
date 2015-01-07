fs     = require('fs')
path   = require('path')
jade   = require('jade')
Config = require('../misc/Config')

require ('../_extra_fluentnode')

class JadeService
    constructor: (config)->
      @.config = config || new Config();
      @.targetFolder = this.config.jade_Compilation;
      @.config.createCacheFolders() # ensure cache folders exists


    enableCache: (value)->                           #set to true to allow caching of jade compiled files
      if(value != undefined)
        @.config.enable_Jade_Cache = value
      else
        @.config.enable_Jade_Cache = true
      @;

    cacheEnabled: ()->
      @.config.enable_Jade_Cache;

    calculateTargetPath: (fileToCompile)->
      @targetFolder.path_Combine(fileToCompile.replace(/\//g,'_')
                                                .replace(/\./g,'_') + '.txt')

    repoPath: ()->
       __dirname.path_Combine('../..')          #calculate the repo path as 3 folders above the current path

    calculateJadePath: (jadeFile)->
      @.repoPath().path_Combine(jadeFile)

    compileJadeFileToDisk: (fileToCompile)->

      fileToCompile_Path = @.calculateJadePath(fileToCompile)


      if (fs.existsSync(fileToCompile_Path)==false)
        return false

      targetFile_Path = @.calculateTargetPath(fileToCompile);

      if (fs.existsSync(targetFile_Path))
          fs.unlinkSync(targetFile_Path)

      fileContents = fs.readFileSync(fileToCompile_Path,  "utf8");
      file_Compiled = jade.compileClient(fileContents , { filename:fileToCompile_Path, compileDebug : false} );

      exportCode =  'var jade = require(\'jade/lib/runtime.js\'); \n' +
                    'module.exports = ' + file_Compiled;


      fs.writeFileSync(targetFile_Path, exportCode);
      return fs.existsSync(targetFile_Path);


    renderJadeFile: (jadeFile, params)->

      if(info)
        info('[Jade-Service] rendering: '  + jadeFile)

      if (this.cacheEnabled() == false)
        jadeFile_Path = @.calculateJadePath(jadeFile)
        if (fs.existsSync(jadeFile_Path))
            return jade.renderFile(jadeFile_Path,params)
        return ""

      targetFile_Path = this.calculateTargetPath(jadeFile);
      if (fs.existsSync(targetFile_Path) == false)
          if (this.compileJadeFileToDisk(jadeFile) == false)
              return "";

      return require(targetFile_Path)(params);

    renderMixin: (file, mixin, params)=>
      safeFile     = file.to_Safe_String()              # only allow letter, numbers, comma and dash
      safeMixin    = mixin.to_Safe_String()
      mixinsFolder ='/source/jade/_mixins/tmp.jade'     # where the mixin file will be expected to exist
      dummyJade    = @.calculateJadePath(mixinsFolder)  # file to be provided to jade.compile

      code = "extends ../_layouts/page_clean\n" +           # add html head and body (with TM css, but no nav bar)
             "include #{safeFile}.jade      \n" +           # imports mixin file
             "block content                 \n" +           # where rendered mixin will be placed
             "  +#{safeMixin}             "             # mixin to render

      return jade.compile(code, {filename: dummyJade })(params)


module.exports = JadeService;