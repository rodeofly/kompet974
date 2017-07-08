ID = 1

HEADERS = ['ID',  'Classe', 'Nom', 'Prénom',  'D1-1.1', 'D1-1.2',  'D1-1.3',  'D1-1.4',  'D1-1.5',  'D1-3.1',  'D1-3.2',  'D1-3.3',  'D1-3.4',  'D1-3.5',  'D1-3.6',  'D1-3.7',  'D2.1', 'D2.2',  'D2.3',  'D2.4',  'D3.1',  'D3.2',  'D3.3',  'D3.4',  'D4.1',  'D4.2',  'D5.1', 'Co.1', 'Co.2', 'Co.3', 'Co.4', 'Co.5', 'Co.6']

SELECTED_DOMS=[]
CATEGORIES = undefined
CLASSES = []
DATA = [HEADERS]
DATA_TEMP = []
#############################################################################################################"
#Drag an Drop interface
DnDFileController = (selector, onDropCallback) ->
  el_ = document.querySelector(selector)

  @dragenter = (e) ->
    e.stopPropagation()
    e.preventDefault()
    el_.classList.add 'dropping'
    $( "#upload" ).addClass "slim"

  @dragover = (e) ->
    e.stopPropagation()
    e.preventDefault()

  @dragleave = (e) ->
    e.stopPropagation()
    e.preventDefault()
    $( "#upload" ).removeClass "slim"
    el_.classList.remove 'dropping'

  @drop = (e) ->
    e.stopPropagation()
    e.preventDefault()
    el_.classList.remove 'dropping'
    onDropCallback e.dataTransfer.files, e
    $( "#upload" ).removeClass "slim"
    $( "#upload" ).hide()

  el_.addEventListener 'dragenter', @dragenter, false
  el_.addEventListener 'dragover', @dragover, false
  el_.addEventListener 'dragleave', @dragleave, false
  el_.addEventListener 'drop', @drop, false
  
#############################################################################################################"
#Construction de la table DATA_TEMP
bigTable = (data) ->  
  options = {thead: true, attrs: {class: 'table'}}
  table = $('<table id="tableau"/>')
  rows = []
  defaults = {th: true, thead: false, tfoot: false, attrs: {}}
  options = $.extend(defaults, options)
  table.attr options.attrs
  # loop through all the rows, we will deal with tfoot and thead later
  i = 0
  while i < data.length
    row = $("<tr data-id='#{data[i][0]}'/>")
    j = 0
    while j < data[i].length
      if i == 0 and options.th
        head = data[i][j]
        console.log head[0..1]
        switch head[0..1]
          when "D1" then domain = "D1"
          when "Co" then domain = "Co"      
          else domain = head[0..1]
        head = "<input type='checkbox' data-row='#{i}'>#{head}" if j is 0
        if j > 3
          if domain is "Co"
            head = "<img  class='thdomain' src='img/#{data[i][j]}.svg' data-domain='#{domain}'><br>#{data[i][j]}"
          else
            head = "<img  class='thdomain' src='img/#{domain}.svg' data-domain='#{domain}'><br>#{data[i][j]}"
          row.append $("<th data-row='#{i}' data-col='#{j}' data-id='#{data[i][j]}' data-dom='#{data[0][j]}'></th>").html(head)
        else
          row.append $("<th data-row='#{i}' data-col='#{j}' data-id='#{data[i][j]}' data-dom='#{data[0][j]}'></th>").html(head)       
      else
        if j is 0
          val = "<input type='checkbox' data-id='#{data[i][j]}''><button class='eleve_id' data-id='#{data[i][j]}''>#{data[i][j]}</button>"
        else 
          val = "#{data[i][j]}"
          color = {"0" : "white", "10" : "red", "25" : "yellow", "40" : "lightGreen", "50" : "green"}[val]
        if color is undefined then color = "white"
        row.append $("<td data-color='#{color}' data-row='#{i}' data-col='#{j}' data-id='#{data[i][0]}' data-dom='#{data[0][j]}'></td>").html(val)
      j = j + 1
    rows.push row
    i = i + 1
  # if we want a thead use shift to get it
  if options.thead
    thead = rows.shift()
    thead = $('<thead />').append(thead)
    table.append thead
  # if we want a tfoot then pop it off for later use
  if options.tfoot
    tfoot = rows.pop()
  # add all the rows
  i = 0
  while i < rows.length
    table.append rows[i]
    i = i + 1
  # and finally add the footer if needed
  if options.tfoot
    tfoot = $('<tfoot />').append(tfoot)
    table.append tfoot
  $( "#scoreTable" ).empty().append(table)     
#############################################################################################################"
#Toggle compétences
toggleEval = (dom) ->
  switch $( ".signifiant[data-item='#{dom}']" ).data "color"
    when "white"      then [color, score] = ["shaded", 0]
    when "shaded"     then [color, score] = ["red", 10]
    when "red"        then [color, score] = ["yellow", 25]
    when "yellow"     then [color, score] = ["lightGreen", 40]
    when "lightGreen" then [color, score] = ["green", 50]
    when "green"      then [color, score] = ["white", 0]
  $( ".signifiant[data-item='#{dom}']" ).attr( "data-color", color )
  $( ".signifiant[data-item='#{dom}']" ).data( "color", color )
  if $( ".selected" ).length is 1
    id = $( ".selected" ).data "id"
    $cell = $( "tr[data-id='#{id}']" ).find( "td[data-dom='#{dom}']" )
    row = $cell.data( "row" )
    col = $cell.data( "col" )
    id  = $cell.data( "id" )
    $cell.attr "data-color", color      
    $cell.data "color", color  
    if not isNaN row * col
      DATA[id][col] = score
      $cell.html score
  else
    $cells = $( "#scoreTable" ).find( "td[data-dom='#{dom}']" )
    ###
    if color isnt "white"
      $( "#scoreTable" ).find( "th[data-dom='#{dom}']" ).show()
    else
      $( "#scoreTable" ).find( "th[data-dom='#{dom}']" ).hide()
    ###
    $cells.each ->
      #if color isnt "white"
        #$( this ).show()
      row = $( this ).data( "row" )
      col = $( this ).data( "col" )
      id  = $( this ).data( "id" )
      $( this ).attr "data-color", color      
      $( this ).data "color", color  
      if not isNaN row * col
        DATA[id][col] = score
        $( this ).html score
      
      #else
        #$( this ).hide()
    
#############################################################################################################"
#Copy to clipboard 
copyToClipboard = (el) ->
  body = document.body
  if (document.createRange and window.getSelection) 
    range = document.createRange()
    sel = window.getSelection()
    sel.removeAllRanges()
    try 
        range.selectNodeContents(el)
        sel.addRange(range)
    catch e
        range.selectNode(el)
        sel.addRange(range)
  else if (body.createTextRange) 
    range = body.createTextRange()
    range.moveToElementText(el)
    range.select()
  document.execCommand("Copy")
##################################################################
#Construction de DATA_TEMP  
go_csv_data = (data) ->
  hide_show_col = ->
    #On remet le menu à zero et on affiche les signifiants      
    $( "#mainselect option[value=Menu]" ).prop "selected", true
    $( ".signifiant" ).each ->
      dom = $(this).data "item"
      if $(this).data("color") is "white"
        $( "#scoreTable" ).find( "th[data-dom='#{dom}'], td[data-dom='#{dom}']" ).hide()
      else
        color = $(this).data("color")
        $cells = $( "#scoreTable" ).find( "th[data-dom='#{dom}'], td[data-dom='#{dom}']" )
        $cells.not("th").data "color", color
        $cells.not("th").attr "data-color", color
        $cells.show()
  temp = $.csv.toArrays(data)
  id = 1
  [DATA,CLASSES] = [[], []]
  for i in temp
    CLASSES.push i[0] if i[0] not in CLASSES
    DATA.push( [id++].concat(i).concat([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]) )
  DATA.unshift HEADERS
  DATA_TEMP = DATA    
  bigTable(DATA_TEMP)
  ###########################################################
  #Menu select pour le mainmenu
  $select = $( "<select id='mainselect'></select>" )
  for o in ["Menu", "Importer", "Sauver Table", "Sauver Catégories", "Copier", "Tous"].concat CLASSES
    $select.append "<option value='#{o}'>#{o}</option>"
  $( "#mainselect" ).remove()
  $( "#menu-item" ).prepend $select       
  $( "#mainselect option[value=Menu]").prop "selected", true
  ##################################################################
  #On selectionne de la classe    
  ##################################################################
  #hide_show_col()
  $( "#mainselect" ).change () ->
    save = (type) ->
      dataStr = "data:text/#{type};charset=utf-8,"
      stringValue = prompt( "Nom du fichier ?", stringValue )
      switch type
        when "json" 
          dataStr += encodeURIComponent(JSON.stringify(CATEGORIES))
        when "csv"
          #dataStr += encodeURIComponent $.csv.fromArrays(DATA_TEMP[1..].map (val) -> return val.slice 1)
          options = {"separator" : "\t"}
          dataStr += encodeURIComponent $.csv.fromArrays(DATA_TEMP,options)
      dlAnchorElem = document.getElementById('save')
      dlAnchorElem.setAttribute("href",     dataStr     )
      dlAnchorElem.setAttribute("download", "#{stringValue}.#{type}")
      dlAnchorElem.click()
    option = $("#mainselect").val()
    switch option
      when "Importer"          then $( "#upload" ).show()
      when "Sauver Table"      then save "csv"        
      when "Sauver Catégories" then save "json"           
      when "Copier"            then $( "#copy" ).click()
      when "Tous"              then bigTable(DATA_TEMP = DATA)      
      else
        if option isnt "menu"
          CLASSE = option
          DATA_TEMP = [HEADERS]
          for o in DATA
            DATA_TEMP.push o if o[1] is CLASSE
          bigTable(DATA_TEMP)
    #hide_show_col()
#############################################################################################################"
class Descripteur
  constructor : (@item,@parent_id, @nom) ->
    @id = ID++
    html = """
<li id='#{@id}' class='descripteur'data-item='#{@item}' data-color='white' data-parent_id='#{@parent_id}'>
    <div class='head'>
        #{@nom}
        <button class='editSignifiant admin'>Éditer</button>
    </div>
</li>"""
    $( "##{@parent_id} .descripteurs ul" ).append html
#############################################################################################################"
class Signifiant
  constructor : (@item, @parent_id, @nom) ->
    @id = ID++
    html = """
<div id='#{@id}' class='signifiant' data-item='#{@item}' data-color='white' data-parent_id='#{@parent_id}' data-nom='#{@nom}'>
    <div class='head'>
        <div class='toggleDescripteurs hide' data-id='#{@id}'></div>#{@nom}
        <button class='addDescripteur admin' data-parent_id='#{@id}'>+Descripteur</button>       
    </div>
    <div class='descripteurs' title='#{@nom}'>
        <ul></ul>
    </div>
</div>"""
    $( "##{@parent_id}" ).find( ".signifiants" ).append html
#############################################################################################################"
class Categorie
  constructor : (@nom, @desc, @iconUrl) ->
    @id = ID++    
    @tab_html = """
<div class='category__tab show' data-id='#{@id}'>
    <div class='head'>
        <img class='tabdomain' src='#{@iconUrl}'>
    </div>
</div>"""
    @eval_html = """
<div id='#{@id}' class='category' data-nom='#{@nom}' data-desc='#{@desc}' data-icon='#{@iconUrl}'>
    <div class='head'>   
        <span class='category__name'>
          <h1>
              <img class='category__icon' src='#{@iconUrl}' data-nom='#{@nom}'>#{@nom}
          </h1>
          <h2>#{@desc}</h2>
        </span>
    </div>
    <button class='addSignifiant admin' data-parent_id='#{@id}'>+Signifiant</button>
    <div class='signifiants'></div>
</div>"""
    $( "#tabs" ).append @tab_html
    $( "#categories_area" ).append @eval_html   
#############################################################################################################"
#On dom ready
$ -> 
  $( "#upload" ).hide()
  $( "#upload .close" ).on "click", -> $( "#upload" ).hide()
  ##################################################################
  #Accidental reload !
  window.onbeforeunload = () -> return ""  
  ################################################################## 
  d1 = $.Deferred()
  d2 = $.Deferred()
  #Construction de DATA
  $.ajax
    type: "GET",
    url: "eleves.csv",
    dataType: "text",
    success: (data) ->
      go_csv_data(data)
      d1.resolve( "Éleves finished !" )
    #Fin Élèves
  ##################################################################
  #Construction du S4C
  $.getJSON "S4C_cat.json", ( data ) -> 
      CATEGORIES = data
      for nom of CATEGORIES
        cat = new Categorie(nom, data[nom].desc, data[nom].iconUrl)
        i=1
        for signifiant, descripteurs of data[nom].signifiants
          s = new Signifiant("#{nom}.#{i++}",cat.id, signifiant)
          j=1
          for descripteur in descripteurs
            new Descripteur("#{s.item}.#{j++}",s.id, descripteur)
      $( "#edit" ).prop "checked", false
      $( ".admin" ).hide()
      $( ".toggleDescripteurs" ).click()
    d2.resolve( "S4C finished !" );
    #Fin du S4C     
  ###################################################################
  #Deffered to resolve Ajax concurrency
  $.when( d1, d2 ).done ( v1, v2 ) ->
    console.log( v1 )
    console.log( v2 )
    $( ".signifiant" ).each ->
      dom = $(this).data "item"
      if $(this).data "color" is "white"
        $( "#scoreTable" ).find( "th[data-dom='#{dom}'], td[data-dom='#{dom}']" ).hide()
      else
        $( "#scoreTable" ).find( "th[data-dom='#{dom}'], td[data-dom='#{dom}']" ).show()
  ##################################################################
  #Drag and Drop file
  dnd = new DnDFileController '#upload', (files) ->
    f = files[0]
    reader = new FileReader
    reader.onloadend = (e) -> go_csv_data(@result)
    reader.readAsText f
    return
  ##################################################################
  #Evenements de l'interface 
  ##################################################################
  #Toggle all checkboxes
  ##################################################################
  $( "body" ).on "click", "input[data-row='0']", ->
    checkBoxes = $("input[type='checkbox']").not($(this))
    if $(this).prop "checked"
      checkBoxes.prop("checked", true).closest("tr").addClass "export"
    else
      checkBoxes.prop("checked", false).closest("tr").removeClass "export"
  ##################################################################
  #Toggle single checkbox  
  ##################################################################
  $( "body" ).on "click", "input[type='checkbox']", ->
    $( this ).closest("tr").toggleClass "export"
    text = ""
    $(".export").each ->
      $(this).find( "td" ).each ->
        text += $(this).text()
        text += ","
      text += "\n"
    $( "#bar" ).text text 
    new Clipboard "#copy"   
  ##################################################################
  #On selectionne un élève ! 
  ##################################################################  
  $( "body" ).on "click", "button.eleve_id", ->
    id = $(this).data "id"
    do_it = ->
      $("td[data-id='#{id}']").each ->
        col = $(this).data( "col" )
        dom = $(this).data( "dom" )
        val = DATA[id][col]
        switch val
          when 0    
            if $(this).data( "color" ) is "shaded"  
              [color, score] = ["shaded", 0]
            else
              [color, score] = ["white", 0]
          when 10 then [color, score] = ["red", 10]
          when 25 then [color, score] = ["yellow", 25]
          when 40 then [color, score] = ["lightGreen", 40]
          when 50 then [color, score] = ["green", 50]
        $( ".signifiant[data-item='#{dom}']" ).attr "data-color", color
        $( ".signifiant[data-item='#{dom}']" ).data "color", color
    if $( ".selected" ).length is 0
      if $( ".signifiant[data-color='shaded']" ).length is 0
        alert "Selectionnez d'abord des signifiants !"
      else
        SELECTED_DOMS = []
        doms = []
        $( ".signifiant[data-color='white']" ).each ->
          $( this ).hide()
          doms.push $( this ).data( "item" )
        $( "th[data-dom='#{dom}'], td[data-dom='#{dom}']" ).hide() for dom in doms
        $( ".signifiant[data-color='shaded']" ).each ->
          SELECTED_DOMS.push $(this).data "item"

        $( ".category" ).each -> 
          $(this).hide() if $( this).find(".signifiant:visible" ).length is 0
        $( "tr[data-id='#{id}']" ).addClass "selected"
        do_it()
    else 
      if $( ".selected" ).is $( this ).closest( "tr" )
        $( ".selected" ).removeClass "selected"
        # On reaffiche tout !
        $( ".category, th, td, #categories_area, .signifiant" ).show()
        for dom in SELECTED_DOMS
          $( ".signifiant[data-item='#{dom}']" ).attr "data-color", "shaded"
          $( ".signifiant[data-item='#{dom}']" ).data "color", "shaded"             
      else
        $( ".selected" ).removeClass "selected"
        $( "tr[data-id='#{id}']" ).addClass "selected"
        do_it()
  ##################################################################
  #Evt : Quand on afficher/cacher les signifiants d'un domaine
  $( "body" ).on "click", ".category__tab", (event) ->
    categoryId = $(this).data( "id" )
    $(this).toggleClass "show hide"
    if $(this).hasClass "show"
      $( "##{categoryId}" ).show()
      $( ".selected" ).removeClass "selected"
    else
      $( "##{categoryId}" ).hide()
  ##################################################################
  #Evt : Quand on toggle un signifiant   
  ################################################################## 
  $( "body" ).on "click", ".signifiant", -> toggleEval( $(this).data "item" )
  ##################################################################
  #CRUD
  ################################################################## 
  $( "body" ).on "click", ".addCategory", ->
    nom = prompt( "Nom de la catégorie ?", "test" )
    desc = prompt( "Description de la catégorie ?", "desc" )
    iconUrl = prompt( "url de l'image de la catégorie ?", "img/D2.svg" )
    new Categorie(nom, desc, iconUrl)
  
  $( "body" ).on "click", ".addSignifiant", ->
    parent_id = $(this).data "parent_id"
    nom = prompt( "Nom du signifiant ?", "signifiant" )
    new Signifiant(parent_id, nom)
  
  $( "body" ).on "click", ".addDescripteur", ->
    parent_id = $(this).data "parent_id"
    nom = prompt( "Nom du descripteur ?", "descripteur" )
    new Descripteur(parent_id, nom)
   
  $( "body" ).on "click", ".toggleDescripteurs", (event) ->
    event.stopPropagation()
    id = $(this).data "id"
    $( this ).toggleClass "hide show"
    $( "##{id} .descripteurs" ).toggle()
  
  $( "body" ).on "click", "input#edit[type='checkbox']", ->
    if $(this).prop "checked"
      $( ".admin" ).show()
    else $( ".admin" ).hide()
  
  $("#categories_area").draggable()
  
  
