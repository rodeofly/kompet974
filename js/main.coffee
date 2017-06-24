ID = 1

HEADERS = ['ID',	'Classe', 'Nom', 'Prénom',	'D1-1.1', 'D1-1.2',	'D1-1.3',	'D1-1.4',	'D1-1.5',	'D1-3.1',	'D1-3.2',	'D1-3.3',	'D1-3.4',	'D1-3.5',	'D1-3.6',	'D1-3.7',	'D2.1', 'D2.2',	'D2.3',	'D2.4',	'D3.1',	'D3.2',	'D3.3',	'D3.4',	'D4.1',	'D4.2',	'D5.1']

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
    return

  @drop = (e) ->
    $( "#upload" ).removeClass "slim"
    $( "#upload" ).hide()
    e.stopPropagation()
    e.preventDefault()
    el_.classList.remove 'dropping'
    onDropCallback e.dataTransfer.files, e
    return

  el_.addEventListener 'dragenter', @dragenter, false
  el_.addEventListener 'dragover', @dragover, false
  el_.addEventListener 'dragleave', @dragleave, false
  el_.addEventListener 'drop', @drop, false
  return  
#############################################################################################################"
#Construction de la table DATA_TEMP
bigTable = (data) ->  
  arrayToTable = (data, options) ->
  'use strict'
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
            head = "<img  class='thdomain' src='img/domaine#{data[i][j][1]}.svg' data-domain='D1-1'><br>#{data[i][j]}"
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
  return table
  table = arrayToTable data,
	  thead: true,
	  attrs: {class: 'table'}	
#############################################################################################################"
#Toggle compétences
toggleEval = (dom) ->
  if $( ".selected" ).length is 1
    $cells = $( ".selected" ).find( "td:visible[data-dom='#{dom}']" )
  else
    $cells = $( "#scoreTable" ).find( "td:visible[data-dom='#{dom}']" )
  switch $( ".significants[data-dom='#{dom}']" ).data "color"
    when "white"      then [color, score] = ["shaded", 0]
    when "shaded"     then [color, score] = ["red", 10]
    when "red"        then [color, score] = ["yellow", 25]
    when "yellow"     then [color, score] = ["lightGreen", 40]
    when "lightGreen" then [color, score] = ["green", 50]
    when "green"      then [color, score] = ["white", 0]
  $( ".significants[data-dom='#{dom}']" ).attr( "data-color", color )
  $( ".significants[data-dom='#{dom}']" ).data( "color", color )  
  $cells.each ->
    row = $( this ).data( "row" )
    col = $( this ).data( "col" )
    id  = $( this ).data( "id" )
    $( this ).attr "data-color", color      
    $( this ).data "color", color  
    if not isNaN row * col
      DATA[id][col] = score
      $( this ).html score
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
  table = bigTable(DATA)
  $('#scoreTable').empty().append(table)
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
    console.log option
    switch option
      when "Importer"
        $( "#upload" ).show()
      when "Sauver"
        stringValue = prompt( "Nom du fichier ?", stringValue )
        dataStr = "data:text/csv;charset=utf-8," + encodeURIComponent($.csv.fromArrays(DATA_TEMP);)
        dlAnchorElem = document.getElementById('save')
        dlAnchorElem.setAttribute("href",     dataStr     )
        dlAnchorElem.setAttribute("download", "#{stringValue}.csv")
        dlAnchorElem.click()
      when "Copier"
        $( "#copy" ).click()
      when "Tous"
        DATA_TEMP = DATA    
        table = bigTable(DATA_TEMP)
        $('#scoreTable').empty().append(table)
      else
        if option isnt "menu"
          console.log option
          CLASSE = option
          DATA_TEMP = [HEADERS]
          for o in DATA
            DATA_TEMP.push o if o[1] is CLASSE
          table = bigTable(DATA_TEMP)
          $('#scoreTable').empty().append(table)  
    $('#mainselect option[value=Menu]').prop "selected", true
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
  #Construction de DATA
  $.ajax
    type: "GET",
    url: "eleves.csv",
    dataType: "text",
    success: (data) -> go_csv_data(data) 
  #Fin de DATA
  #############################################################################################################"
  #Drag and Drop file
  dnd = new DnDFileController '#upload', (files) ->
    f = files[0]
    reader = new FileReader
    reader.onloadend = (e) -> go_csv_data(@result)
    reader.readAsText f
    return
  #############################################################################################################"
  #Construction du S4C
  $.getJSON "S4C.json", ( data ) -> 
    EVALS = data
    #################
    #Boutons .domain 
    evals = Object.keys EVALS
    for k of EVALS
      $html = $( """
  <div id="#{k}" class="domain">
    <div class="nom">#{k} : #{EVALS[k]['subtitle']}</div>
  </div>    
      """ )
      n=0
      for s of EVALS[k].significants
        id = ID++
        n++
        $s = $( "<div class='significants' data-color='white' data-dom='#{k}.#{n}'>#{s}<img class='more' src='css/icons/more.png' data-id='#{id}'><div class='info' id='#{id}' title='#{s}'><ul></ul></div></div>" )
        for i in EVALS[k].significants[s]
          $s.find(".info ul").append "<li class='item'>#{i}</li>"
        $html.append $s
      $("#significants_area").append $html
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
  #Fin du S4C
  
  ##################################################################  
#############################################################################################################
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
  #On selectionne de la classe    
  ##################################################################  
  $( "body" ).on "click", "button.eleve_id", ->
    if $( ".selected" ).length is 1
      $( ".selected" ).removeClass "selected"
    else
      id = $(this).data "id"
      $( "tr[data-id='#{id}']" ).addClass "selected"
      
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
    
  ##################################################################
  #On selectionne un domaine   
  ##################################################################
  $( ".tabdomain" ).addClass "show"
  $( ".tabtoggler[data-domain='all']" ).hide()
  
  $( ".tabtoggler[data-domain='none']" ).on "click", ->
    $( "#significants_area, .tabdomain" ).hide()
    $( "tr, .tabtoggler[data-domain='all']" ).show()
    $(this).hide()
    
  $( ".tabtoggler[data-domain='all']" ).on "click", ->
    $( ".tabdomain" ).show()
    $("#significants_area").show()
    $( ".tabtoggler[data-domain='none']" ).show()
    $(this).hide()
    
  $( ".tabdomain" ).on "click", (event) ->
    dom = $(this).data( "domain" )
    $(this).toggleClass "show hide"
    $( "##{dom}" ).toggle()
    if $(this).hasClass "hide"
      $( "th[data-dom^='#{dom}'],td[data-dom^='#{dom}']" ).hide()
    else
      $( "th[data-dom^='#{dom}'],td[data-dom^='#{dom}']" ).show()
  ##################################################################
  #On selectionne d'un signifiant   
  ################################################################## 
  $( "body" ).on "click", ".significants", -> 
    toggleEval( $(this).data "dom" )  
  
 
      
