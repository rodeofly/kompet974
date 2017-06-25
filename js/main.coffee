ID = 1

HEADERS = ['ID',  'Classe', 'Nom', 'Prénom',  'D1-1.1', 'D1-1.2',  'D1-1.3',  'D1-1.4',  'D1-1.5',  'D1-3.1',  'D1-3.2',  'D1-3.3',  'D1-3.4',  'D1-3.5',  'D1-3.6',  'D1-3.7',  'D2.1', 'D2.2',  'D2.3',  'D2.4',  'D3.1',  'D3.2',  'D3.3',  'D3.4',  'D4.1',  'D4.2',  'D5.1']

EVALS = undefined
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
    return

  @dragover = (e) ->
    e.stopPropagation()
    e.preventDefault()
    return

  @dragleave = (e) ->
    e.stopPropagation()
    e.preventDefault()
    $( "#upload" ).removeClass "slim"
    #el_.classList.remove('dropping');

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
  return  
#############################################################################################################"
#Construction de la table DATA_TEMP
bigTable = (data) ->  
  options = 
    thead: true
    attrs: {class: 'table'}
  table = $('<table id="tableau"/>')
  rows = []
  defaults = 
    th: true
    thead: false
    tfoot: false
    attrs: {}
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
        head = "<input type='checkbox' data-row='#{i}'>#{head}" if j is 0
        if j > 3
          if j < 16
            head = "<img class='thdomain' src='img/domaine#{data[i][j][1..3]}.svg' data-domain='D1-1'><br>#{data[i][j]}"                   
          else
            head = "<img  class='thdomain' src='img/domaine#{data[i][j][1]}.svg' data-domain='D#{data[i][j][1]}'><br>#{data[i][j]}"
          row.append $("<th data-row='#{i}' data-col='#{j}' data-id='#{data[i][j]}' data-dom='#{data[0][j]}'/th>").html(head)
        else
          row.append $("<th data-row='#{i}' data-col='#{j}' data-id='#{data[i][j]}' data-dom='#{data[0][j]}'></th>").html(head)
        
      else
        if j is 0
          val = "<input type='checkbox' data-id='#{data[i][j]}''><button class='eleve_id' data-id='#{data[i][j]}''>#{data[i][j]}</button>"
        else 
          val = "#{data[i][j]}"
          color = {0 : "white", 10 : "red", 25 : "yellow", 40 : "lightGreen", 50 : "green"}[val]
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
  switch $( ".significants[data-dom='#{dom}']" ).data "color"
    when "white"      then [color, score] = ["shaded", 0]
    when "shaded"     then [color, score] = ["red", 10]
    when "red"        then [color, score] = ["yellow", 25]
    when "yellow"     then [color, score] = ["lightGreen", 40]
    when "lightGreen" then [color, score] = ["green", 50]
    when "green"      then [color, score] = ["white", 0]
  $( ".significants[data-dom='#{dom}']" ).attr( "data-color", color )
  $( ".significants[data-dom='#{dom}']" ).data( "color", color )
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
    if color isnt "white"
      $( "#scoreTable" ).find( "th[data-dom='#{dom}']" ).show()
    else
      $( "#scoreTable" ).find( "th[data-dom='#{dom}']" ).hide()
    $cells.each ->
      if color isnt "white"
        $( this ).show()
        row = $( this ).data( "row" )
        col = $( this ).data( "col" )
        id  = $( this ).data( "id" )
        $( this ).attr "data-color", color      
        $( this ).data "color", color  
        if not isNaN row * col
          DATA[id][col] = score
          $( this ).html score
      else
        $( this ).hide()
    
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
  temp = $.csv.toArrays(data)
  id = 1
  DATA = []
  CLASSES = []
  for i in temp
    CLASSES.push i[0] if i[0] not in CLASSES
    DATA.push( [id++].concat(i).concat([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]) )
  DATA.unshift HEADERS
  DATA_TEMP = DATA    
  bigTable(DATA_TEMP)
  ###########################################################
  #Menu select pour le mainmenu
  $select = $( "<select id='mainselect'></select>" )
  for o in ["Menu", "Importer", "Sauver","Copier", "Tous"].concat CLASSES
    $select.append "<option value='#{o}'>#{o}</option>"
  $( "#mainselect" ).remove()
  $( "#mainmenu" ).prepend $select       
  $( "#mainselect option[value=Menu]").prop "selected", true
  ##################################################################
  #On selectionne de la classe    
  ##################################################################
  $( "#mainselect" ).change () ->
    option = $("#mainselect").val()
    switch option
      when "Importer"
        $( "#upload" ).show()
      when "Sauver"
        stringValue = prompt( "Nom du fichier ?", stringValue )
        dataStr = "data:text/csv;charset=utf-16," + encodeURIComponent($.csv.fromArrays(DATA_TEMP))
        dlAnchorElem = document.getElementById('save')
        dlAnchorElem.setAttribute("href",     dataStr     )
        dlAnchorElem.setAttribute("download", "#{stringValue}.csv")
        dlAnchorElem.click()
      when "Copier"
        $( "#copy" ).click()
      when "Tous"
        DATA_TEMP = DATA    
        bigTable(DATA_TEMP)      
      else
        if option isnt "menu"
          CLASSE = option
          DATA_TEMP = [HEADERS]
          for o in DATA
            DATA_TEMP.push o if o[1] is CLASSE
          bigTable(DATA_TEMP)
    #On remet le menu à zero et on affiche les signifiants      
    $( "#mainselect option[value=Menu]" ).prop "selected", true
    $( ".significants" ).each ->
      dom = $(this).data "dom"
      if $(this).data "color" is "white"
        $( "#scoreTable" ).find( "th[data-dom='#{dom}'], td[data-dom='#{dom}']" ).hide()
      else
        $( "#scoreTable" ).find( "th[data-dom='#{dom}'], td[data-dom='#{dom}']" ).show()
#############################################################################################################"
#############################################################################################################"
#############################################################################################################"
#On dom ready
$ ->
  $( "#upload" ).hide()
  $( "#upload .close" ).on "click", -> $( "#upload" ).hide()
  #############################################################################################################"
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
  #Fin de DATA
  ##################################################################
  #Construction du S4C
  $.getJSON "S4C.json", ( data ) -> 
    EVALS = data
    #################
    #Boutons .domain 
    evals = Object.keys EVALS
    for k of EVALS
      $html = $( "<div id='#{k}' class='domain'><div class='nom'><img src='img/domaine#{k[1..]}.svg' data-domain='#{k}'>#{k} : #{EVALS[k]['subtitle']}</div><div class='significants_list'></div></div>" )
      n=0
      for s of EVALS[k].significants
        id = ID++
        n++
        $s = $( "<div class='significants' data-color='white' data-dom='#{k}.#{n}'>#{k}.#{n} : #{s}<img class='more' src='css/icons/more.png' data-id='#{id}'><div class='info' id='#{id}' title='#{s}'><ul></ul></div></div>" )
        for i in EVALS[k].significants[s]
          $s.find(".info ul").append "<li class='item'>#{i}</li>"
        $html.find(".significants_list").append $s
      $("#significants_area").append $html
      $( ".tabdomain" )
        .addClass "hide"
        .hide()
      $( ".domain" ).hide()
    ##################################################################
    #sugar
    $("#significants_area").draggable()
    $( ".info" ).dialog
      autoOpen: false
      width   : "auto"   
    $( "body" ).on "click", ".more", (event) -> 
      event.stopPropagation()
      id = $( this ).data( "id" )
      $( "##{id}" ).dialog "open"
    d2.resolve( "S4C finished !" );
  #Fin du S4C
      
  ###################################################################
  #Deffered to resolve Ajax concurrency
  $.when( d1, d2 ).done ( v1, v2 ) ->
    console.log( v1 )
    console.log( v2 )
    $( ".significants" ).each ->
      dom = $(this).data "dom"
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
  ##################################################################
  #Evenements de l'interface 
  ##################################################################
  ##################################################################
  #Toggle all checkboxes
  ##################################################################
  $( "body" ).on "click", "input[data-row='0']", ->
    checkBoxes = $("input[type='checkbox']").not($(this))
    if $(this).prop "checked"
      checkBoxes.prop("checked", true)
      checkBoxes.closest("tr").addClass "export"
    else
      checkBoxes.prop("checked", false)
      checkBoxes.closest("tr").removeClass "export"
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
        $( ".significants[data-dom='#{dom}']" ).attr "data-color", color
        $( ".significants[data-dom='#{dom}']" ).data "color", color
    if $( ".selected" ).length is 0
      if $( ".significants[data-color='shaded']" ).length is 0
        alert "Selectionnez d'abord des signifiants !"
      else
        $( ".significants[data-color='white']" ).hide()
        $( "tr[data-id='#{id}']" ).addClass "selected"
        do_it()
    else 
      if $( ".selected" ).is $( this ).closest( "tr" )
        $( ".selected" ).removeClass "selected"
        # On remet les signifiants séléctionnés
        $( "#significants_area, .significants" ).show()
        $( "#scoreTable" ).find( "th:visible" ).each ->
          dom = $(this).data "dom"
          $( ".significants[data-dom='#{dom}']" ).attr "data-color", "shaded"
          $( ".significants[data-dom='#{dom}']" ).data "color", "shaded"        
      else
        $( ".selected" ).removeClass "selected"
        $( "tr[data-id='#{id}']" ).addClass "selected"
        do_it()   
  ##################################################################
  #On selectionne un domaine   
  ##################################################################
  #Par défaut on affiche rien
  $( ".tabtoggler[data-domain='none']" ).hide()
  ##################################################################
  #Evt : Quand on veux cacher les domaines  
  ################################################################## 
  $( ".tabtoggler[data-domain='none']" ).on "click", ->
    $( "#significants_area, .tabdomain" ).hide()
    $( ".tabtoggler[data-domain='all']" ).show()
    $(this).hide()
  ##################################################################
  #Evt : Quand on veux afficher les domaines   
  ##################################################################   
  $( ".tabtoggler[data-domain='all']" ).on "click", ->
    $( ".tabdomain" ).show()
    $("#significants_area").show()
    $( ".tabtoggler[data-domain='none']" ).show()
    $(this).hide()
  ##################################################################
  #Evt : Quand on afficher/cacher les signifiants d'un domaine
  ##################################################################   
  $( ".tabdomain" ).on "click", (event) ->
    dom = $(this).data( "domain" )
    $(this).toggleClass "show hide"

    if $(this).hasClass "show"
      $( "##{dom}" ).show()
      $( ".selected" ).removeClass "selected"
    else
      $( "##{dom}" ).hide()
  ##################################################################
  #Evt : Quand on toggle un signifiant   
  ################################################################## 
  $( "body" ).on "click", ".significants", -> 
    toggleEval( $(this).data "dom" )  
  
 
      
