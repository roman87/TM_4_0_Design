fs             = require('fs')
path           = require('path')
request        = require('request')
Cache_Service  = require('teammentor').Cache_Service
    

# this needs to me all moved into the 'teammentor' module
# at the moment this could be called Docs_TM_Service and be an accurate representation of this code
class TeamMentor_Service

  constructor: ->
    @.disableCache           = false
    @._name                  = 'docs'
    @._tmSite                = 'https://docs.teammentor.net'
    @._tmWebServices         = '/Aspx_Pages/TM_WebServices.asmx/'
    @.cache                  = new Cache_Service("docs_cache")
    @.tm_35_Server           = 'https://tmdev01-uno.teammentor.net'   # starting to move this dependencies here


  asmx_GetFolderStructure_Libraries: (callback)=>
    @cache.json_POST @.calculateTargetUrl('GetFolderStructure_Libraries'), {}, callback

  asmx_GetGUIObjects: (callback)=>
    @cache.json_POST @.calculateTargetUrl('GetGUIObjects'), {}, callback


  calculateTargetUrl: (wsName)->
    @._tmSite + @._tmWebServices + wsName

  getArticlesMetadata: (callback)=>
    @asmx_GetGUIObjects (guiObjects)->

      articlesMetadata = {};
      mappings      = guiObjects.d.GuidanceItemsMappings;
      uniqueStrings = guiObjects.d.UniqueStrings;

      articlesMetadata._numberOfArticles = 0;

      mappings.forEach (mapping)->
        keys = mapping.split(',');
        metadata =
                        Id         : uniqueStrings[keys[0]],
                        Title      : uniqueStrings[keys[2]],
                        Technology : uniqueStrings[keys[3]],
                        Phase      : uniqueStrings[keys[4]],
                        Type       : uniqueStrings[keys[5]],
                        Category   : uniqueStrings[keys[6]]

        articlesMetadata[metadata.Id]= metadata;
        articlesMetadata._numberOfArticles++;

      callback articlesMetadata;

  getLibraryData: (callback)->
    @asmx_GetFolderStructure_Libraries (getFolderStructure)=>
      @.getArticlesMetadata (articlesMetadata)=>
    
        libraryData = [];
        getFolderStructure.d.forEach (tmLibrary)->
                library =
                            Title   : tmLibrary.name,
                            Folders : [],
                            Views   : [],
                            Articles: {}
                
                tmLibrary.guidanceItems = [];
                
                tmLibrary.views.forEach (tmView)->
                        view = { Title: tmView.caption, Articles: [] };
                    
                        tmView.guidanceItems.forEach (guidanceItemId)->
                                articleMetadata = articlesMetadata[guidanceItemId];
                                view   .Articles.push(articleMetadata);
                                library.Articles[articleMetadata.Id] = articleMetadata;
                        library.Views.push(view);
                libraryData.push(library);

        callback libraryData

module.exports = TeamMentor_Service;