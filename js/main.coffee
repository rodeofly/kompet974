#for DOM elements
ID = 1000

STUDENTS_LENGTH = 0
STUDENTS = {}

SELECTED_DOMS=[]
DOMAINES = {}

DATA = []
DATA_TEMP = {}

CLASSES = []
CURRENT_EVAL = {}
CURRENT_CLASSE = undefined


#############################################################################################################"
timer = (name) ->
  start = new Date()
  return stop : ->
    end  = new Date()
    time = end.getTime() - start.getTime()
    console.log('Timer:', name, 'finished in', time, 'ms')
#############################################################################################################"
class Eleve
  constructor : (@id, @classe, @nom, @prenom) ->
    STUDENTS_LENGTH++
    @evaluation = {}
    @html = """
<div id="#{@id}" class="eleve" data-classe="#{@classe}" data-nom="#{@nom}" data-prenom="#{@prenom}">
  <div class="content">
    <button class='absent button black'>#{@classe} - Présent</button>
    <button class='present button white' style='display:none;'>#{@classe} - Absent</button>
    <button class='save button red' style='display:none;'>Valider</button>   
    <div class="evaluation"></div>
    <h1>#{@nom} #{@prenom}</h1>
    
  </div>
</div>
"""
  
#############################################################################################################"
class Descripteur
  constructor : (@descripteur, @item,@signifiantItem ) ->
    @id = ID++
    @html = """
<li id='#{@id}' class='descripteur' data-descripteur='#{@descripteur}' data-item='#{@item}' data-signifiant-item='#{@signifiantItem}' data-color='white'>
    <div class='head'>#{@descripteur}</div>
</li>"""
    
#############################################################################################################"
class Signifiant
  constructor : (@signifiant, @item, @domaine ) ->
    @id = ID++
    @html = """
<div id='#{@id}' class='signifiant' data-item='#{@item}' data-color='white' data-signifiant='#{@signifiant}' data-domaine='#{@domaine}'>
    <div class='head'>
        <button class='toggleDescripteurs button black hide' data-id='#{@id}'>[Détails]</button> #{@signifiant}
    </div>
    <div class='descripteurs'>
        <ul></ul>
    </div>
</div>"""

#############################################################################################################"
class Domaine
  constructor : (@domaine, @desc, @iconUrl) ->
    @id = ID++    
    @htmlTab = """
<div class='domaine__tab hide' data-id='#{@id}' data-domaine='#{@domaine}'>
    <div class='head'>
        <img class='domaine__icon' src='#{@iconUrl}'>
    </div>
</div>"""
    @html = """
<div id='#{@id}' class='domaine' data-domaine='#{@domaine}' data-description='#{@desc}' data-icon='#{@iconUrl}'>
    <div class='head'>  
        <img class='domaine__icon' src='#{@iconUrl}' data-domaine='#{@domaine}'>
        
        
        <button class='toggleDomDescription button black hide' data-id='#{@id}'>info</button> 
        <div class="domDescription" style="display:none;"><div class='domaine__name'>#{@domaine} : #{@desc}</div></div>
    </div>
    <div class='signifiants'></div>
</div>"""
####################################################################
####################################################################
####################################################################
d3 = $.Deferred()
$.fn.extend
  html5_qrcode: (qrcodeSuccess, qrcodeError, videoError) ->
    @each ->
      currentElem = $(this)
      height = currentElem.height()
      width = currentElem.width()
      if height == null
        height = 250
      if width == null
        width = 300
      vidElem = $( "<video id='cam' width='#{width}px' height='#{height}px'></video>").appendTo(currentElem)
      canvasElem = $("<canvas id='qr-canvas' width='#{width - 2}px' height='#{height - 2}px' style='display:none;'></canvas>").appendTo(currentElem)
      video = vidElem[0]
      canvas = canvasElem[0]
      context = canvas.getContext('2d')
      localMediaStream = undefined
      audioSelect = document.querySelector('select#audioSource')
      videoSelect = document.querySelector('select#videoSource')
      
      scan = ->
        if localMediaStream
          context.drawImage video, 0, 0, 307, 250
          try
            qrcode.decode()
          catch e
            qrcodeError e, localMediaStream
          $.data currentElem[0], 'timeout', setTimeout(scan, 500)
        else
          $.data currentElem[0], 'timeout', setTimeout(scan, 500)
          
      gotDevices = (deviceInfos) ->
        i = 0
        while i != deviceInfos.length
          deviceInfo = deviceInfos[i]
          option = document.createElement('option')
          option.value = deviceInfo.deviceId
          if deviceInfo.kind == 'audioinput'
            option.text = deviceInfo.label or 'microphone ' + audioSelect.length + 1
            audioSelect.appendChild option
          else if deviceInfo.kind == 'videoinput'
            option.text = deviceInfo.label or 'camera ' + videoSelect.length + 1
            videoSelect.appendChild option
          else
            console.log 'Found ome other kind of source/device: ', deviceInfo
          ++i
        return

      getStream = ->
        if window.stream
          window.stream.getTracks().forEach (track) ->
            track.stop()
            return
        constraints = 
          audio: optional: [ { sourceId: audioSelect.value } ]
          video: optional: [ { sourceId: videoSelect.value } ]
        navigator.mediaDevices.getUserMedia(constraints).then(gotStream).catch handleError
        return

      gotStream = (stream) ->
        window.stream = stream
        # make stream available to console
        video.srcObject = stream
        localMediaStream = stream
        $.data currentElem[0], 'stream', stream
        video.play()
        $.data currentElem[0], 'timeout', setTimeout(scan, 1000)

      handleError = (error) -> console.log 'Error: ', error
      

      # Call the getUserMedia method with our callback functions
      if navigator.getUserMedia
        navigator.mediaDevices.enumerateDevices().then(gotDevices).then(getStream).catch handleError
        audioSelect.onchange = getStream
        videoSelect.onchange = getStream  
      else
        console.log 'Native web camera streaming (getUserMedia) not supported in this browser.'
        # Display a friendly "sorry" message to the user

      qrcode.callback = (result) ->
        qrcodeSuccess result, localMediaStream
       
    # end of html5_qrcode
  html5_qrcode_stop: ->
    @each ->
      #stop the stream and cancel timeouts
      $(this).data('stream').getVideoTracks().forEach (videoTrack) ->
        videoTrack.stop()
        return
      clearTimeout $(this).data('timeout')
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
    el_.classList.remove 'dropping'
    $( "#upload" ).removeClass "slim"

  @drop = (e) ->
    e.stopPropagation()
    e.preventDefault()
    el_.classList.remove 'dropping'
    onDropCallback e.dataTransfer.files, e
    $( "#upload" ).removeClass( "slim" ).hide()

  el_.addEventListener 'dragenter'  , @dragenter, false
  el_.addEventListener 'dragover'   , @dragover , false
  el_.addEventListener 'dragleave'  , @dragleave, false
  el_.addEventListener 'drop'       , @drop     , false
##################################################################
#Drag and Drop file
dnd = new DnDFileController '#upload', (files) ->
  f = files[0]
  reader = new FileReader
  reader.onloadend = (e) -> addStudentsCards(@result)
  reader.readAsText f
  return
####################################################################
####################################################################
####################################################################
#Menu select pour le mainmenu - missing : "Sauver Table", "Sauver Catégories", "Tous"  
do_menu = () ->
  $( "#mainselect" ).remove()
  $select = $( "<select id='mainselect'><option value='defaut'>Menu</option></select>" )
  for o in ["Importer", "Charger Local", "Effacer Local", "Imprimer les QR-codes", "Copier"].concat CLASSES
    $select.append "<option value='#{o}'>#{o}</option>"
  $( "#tabs" ).prepend $select       
  $( "#mainselect option[value=Menu]").prop "selected", true
  $( "#mainselect" ).selectmenu
    width  : 50
    height : 50
    change : -> 
      save = (type) ->
        dataStr = "data:text/#{type};charset=utf-8,"
        stringValue = prompt( "Nom du fichier ?", stringValue )
        switch type
          when "json" 
            dataStr += encodeURIComponent(JSON.stringify(DOMAINES))
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
        when "Importer" then $( "#upload" ).show()
        when "Charger Local"
          if localStorage.DATA
            DATA = JSON.parse localStorage.DATA
            console.log DATA
            alert("Nous avons retrouvé #{DATA.length} entrée(s) dans le navigateurs :)")
          else
            DATA = []
            alert("Nous n'avons retrouvé aucune entrée dans le navigateurs :(")
        when "Effacer Local"
          if confirm('Êtes-vous sur de vouloir tout effacer ?') 
            localStorage.DATA = []
        when "Imprimer les QR-codes"
          if STUDENTS_LENGTH is 1
            alert "importer des élèves d'abord !"
          else
            $html = $( "<div class='qrcodes'></div>" )
            note = 
              "shaded"     : "NE"
              "red"        : "insuffisant"
              "yellow"     : "fragile"
              "lightGreen" : "satisfaisant"
              "green"      : "très bien"
            for i in [1..25]
              $nom = $("<div class='grid'><div class='eleve'>(#{i}) #{STUDENTS[i].nom}<br>#{STUDENTS[i].prenom}</div></div>")
              for j in ["shaded", "red", "yellow", "lightGreen", "green" ]
                $qrcode = $( "<div class='qrcodePrint'/>" )
                $qrcode.qrcode({width: 128,height: 128,text: "#{i}-#{j}"})
                $nom.append( $qrcode.append("<br><span>#{note[j]}</span>") )
                $html.append $nom
            $( "html" ).css('background-image', 'none')
            $( "body" ).empty().append $html
            
        when "Sauver Table"      then save "csv"        
        when "Sauver Catégories" then save "json"           
        when "Copier"
          options= {"separator" : "\t"}
          $( "#clipboard" ).text( $.csv.fromArrays DATA, options )
          new Clipboard "#copy"     
          $( "#copy" ).click()
        else
          CURRENT_CLASSE = option
          $( "#eleves" ).show()
          $( ".eleve:not([data-classe='#{option}']) " ).hide()
          $( ".eleve[data-classe='#{option}'] " ).show()
          $( "#editEval" ).show()
      $( "#mainselect option[value='defaut']").prop "selected", true     
####################################################################
#Construction des cartes élèves  
addStudentsCards = (data) ->
  CLASSES = []
  STUDENTS = {}
  $( "#eleves" ).empty()
  # data.csv : id, classe, nom, prenom
  students_arrays = $.csv.toArrays(data)
  for array in students_arrays
    s = new Eleve(array[0],array[1],array[2], array[3])
    STUDENTS[s.id] = s
    CLASSES.push s.classe if s.classe not in CLASSES
    $( "#eleves" ).append s.html
  do_menu()
  $( "#eleves" ).hide()
  console.log "Il y avait #{students_arrays.length} entrée(s) ! Il y a #{CLASSES.length} classe(s) dans le menu !"   
#On dom ready
$ ->
  

    
  $( "#upload .close" ).on "click", -> $( "#upload" ).hide()
  ##################################################################
  #Accidental reload !
  window.onbeforeunload = () -> return ""  
  ################################################################## 
  d1 = $.Deferred()
  d2 = $.Deferred()
  
  #Construction de DATA
  $.ajax
    type: "GET"
    url: "eleves.csv"
    dataType: "text"
    success: (data) -> 
      addStudentsCards(data)      
      d1.resolve( "Éleves finished !" )
    error: ->
      alert "aucun élève importé !"
      d1.resolve( "Éleves finished !" )
  #Fin Élèves
  ##################################################################
  #Construction du S4C
  $.getJSON "S4C_cat.json", ( data ) -> 
      DOMAINES = data
      for nom of DOMAINES
        CURRENT_EVAL[nom] = {}
        dom = new Domaine(nom, data[nom].description, data[nom].iconUrl)
        $( "#tabs" ).append dom.htmlTab
        $( "#domaines_area" ).append dom.html   
        i=1
        for signifiant, descripteurs of data[nom].signifiants
          sig = new Signifiant(signifiant, "#{nom}.#{i++}", dom.domaine)
          $( ".domaine[data-domaine='#{sig.domaine}']" ).find( ".signifiants" ).append sig.html
          j=1
          for descripteur in descripteurs
            des = new Descripteur(descripteur, "#{sig.item}.#{j++}",sig.item)
            $( ".signifiant[data-item='#{sig.item}'] .descripteurs ul" ).append des.html     
      $( "#edit" ).prop "checked", false      
      $( ".toggleDescripteurs" ).click()      
      $( ".domaine, .domaine__tab" ).hide()
      d2.resolve( "S4C finished !" )
      #Fin du S4C     
  ###################################################################
  #Deffered to resolve Ajax concurrency
  $.when( d1, d2 ).done ( v1, v2 ) ->
    console.log( v1 )
    console.log( v2 )   
    do_menu()
        
  
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
  #Evt : Quand on toggle un domaine
  ##################################################################
  $( "body" ).on "click", ".domaine__tab", (event) ->
    id = $(this).data( "id" )
    dom = $(this).data( "domaine" )
    $(this).toggleClass "show hide"
    if $(this).hasClass "show"
      $( "##{id}, ##{id} .signifiants, ##{id} .signifiant" ).show()
    else     
      index = SELECTED_DOMS.indexOf(dom)
      SELECTED_DOMS.splice(index, 1) if (index > -1)
      $( "##{id}" ).hide()   
  
  $( "body" ).on "click", ".toggleDomDescription", (event) ->
    id = $(this).data( "id" )
    $( "##{id} .domDescription" ).toggle()
    
  ##################################################################
  #Evt : Quand on toggle un signifiant   
  ##################################################################
  #Toggle signifiant
  toggleSignifiant = (item) ->
    $s    = $( ".signifiant[data-item='#{item}']" )
    dom   = $s.data "domaine"
    color = $s.data "color"

    switch color
      when "white"      then [color, score] = ["shaded", 0]
      when "shaded"     then [color, score] = ["red", 10]
      when "red"        then [color, score] = ["yellow", 25]
      when "yellow"     then [color, score] = ["lightGreen", 40]
      when "lightGreen" then [color, score] = ["green", 50]
      when "green"
        if $( "#domaines_area .domaine[data-domaine='#{dom}']" ).hasClass "freeze"
          [color, score] = ["shaded", 0]
        else
          [color, score] = ["white", 0]
    $s.attr( "data-color", color )
    $s.data( "color", color )
    CURRENT_EVAL[dom][item] =
      note    : score
      couleur : color
    
    
    if $( "#domaines_area .domaine[data-domaine='#{dom}']" ).hasClass "freeze"
      if $( ".selected" ).length > 0
        id = $( ".selected" ).attr "id"
        $( ".selected .eval_sig[data-item='#{item}']" ).data "color", color
        $( ".selected .eval_sig[data-item='#{item}']" ).attr "data-color", color
        DATA_TEMP[id][dom][item] =
          note       : score
          couleur    : color
    else
      #On crée une entrée dans DATA_TEMP pour ce signifiant
      if color isnt "white"
        $( "#freeze" ).show()
        SELECTED_DOMS.push dom if dom not in SELECTED_DOMS
        SELECTED_DOMS.sort()
        $( ".eleve[data-classe='#{CURRENT_CLASSE}']" ).each ->
          id = $(this).attr "id"
          DATA_TEMP[id] = {} if DATA_TEMP[id] is undefined      
          DATA_TEMP[id][dom] = {} if DATA_TEMP[id][dom] is undefined
          DATA_TEMP[id][dom][item] = {} if DATA_TEMP[id][dom][item] is undefined
      else
        if $( ".signifiant:not([data-color='white'])" ).length is 0
          $( "#freeze" ).hide()
            
  $( "body" ).on "click", ".signifiant", -> toggleSignifiant( $(this).data "item" )
   
  $( "body" ).on "click", ".toggleDescripteurs", (event) ->
    event.stopPropagation()
    id = $(this).data "id"
    $( this ).toggleClass "hide show"
    $( "##{id} .descripteurs" ).toggle()
  
  ##################################################################
  #Evt : Quand on crée une éval
  ################################################################## 
  $( "body" ).on "click", "#editEval", ->
    
    if CURRENT_CLASSE is undefined
      alert "selectionner une classe"
    else
      $( this ).hide()
      $( "#eleves, #validEval, #qrcodeModeStart" ).hide()
      $( ".domaine__tab" ).show()
      if $( ".signifiant:not([data-color='white'])" ).length > 0
        $( "#freeze" ).show() 
      for dom in SELECTED_DOMS
        $( ".domaine[data-domaine='#{dom}'], .domaine[data-domaine='#{dom}'] .signifiant" ).show()
        $( ".domaine[data-domaine='#{dom}'], #domaines_area" ).removeClass "freeze"
        $( ".signifiant[data-descripteur='#{dom}']" )
          .attr "data-color", "shaded"
          .data "color", "shaded"
  
  ##################################################################
  #Evt : Quand on freeze une éval   
  ##################################################################   
  $( "body" ).on "click", "#freeze", ->
    $( "#qrcodeModeStart" ).show()
    $( ".domaine__tab, .signifiant[data-color='white']" ).hide()

    $( this ).hide()
    $( "#eleves, #editEval, #validEval" ).show()
    $( "#domaines_area" ).addClass "freeze"
    
    $html = $( "<div/>" )
    t1 = timer('First loop')
    for d in SELECTED_DOMS
      $( ".domaine[data-domaine='#{d}']" ).addClass "freeze"
      $html.append "<div class='eval_dom' data-domaine='#{d}'></div>"
      signifiants = Object.keys CURRENT_EVAL[d]
      for s in signifiants.sort()
        if CURRENT_EVAL[d][s].couleur isnt "white"
          $html.find( ".eval_dom[data-domaine='#{d}']" ).append "<div class='eval_sig' data-item='#{s}' data-color='#{CURRENT_EVAL[d][s].couleur}' data-note='#{CURRENT_EVAL[d][s].note}'></div>"
    t1.stop()
    $( ".domaine" ).filter( ":not(.freeze)" ).hide()
    $( ".eleve[data-classe='#{CURRENT_CLASSE}'] .evaluation" ).empty()
    $( ".eleve[data-classe='#{CURRENT_CLASSE}']" ).find( ".evaluation" ).append $html.html()
    
    t2 = timer('Second loop')
    for id of DATA_TEMP
      for dom in SELECTED_DOMS
        $( ".domaine[data-domaine='#{dom}'] .signifiant:not([data-color='white'])" ).each ->
          item = $( this ).data "item"
          #si les élèves n'ont jamais été évalué, on, leur assigne une couleur par défaut
          if DATA_TEMP[id][dom][item].couleur isnt undefined
            $( "##{id} .eval_sig[data-item='#{item}']" ).data "color", DATA_TEMP[id][dom][item].couleur
            $( "##{id} .eval_sig[data-item='#{item}']" ).attr "data-color", DATA_TEMP[id][dom][item].couleur
          else
            color = $( this ).data "color"
            $( "#id .eval_sig[data-item='#{item}']" ).data "color", color
            $( "#id .eval_sig[data-item='#{item}']" ).attr "data-color", color
            DATA_TEMP[id][dom][item].couleur = color
    t2.stop()
  ##################################################################
  #Evt : Quand on clique sur un eleve absent  
  ##################################################################
  $( "body" ).on "click", ".eleve .absent", (e) ->
    e.stopPropagation()
    $(this).toggle()
    $(this).siblings( ".present" ).toggle()
    $( this ).closest( ".eleve" ).addClass "absent"
  
  $( "body" ).on "click", ".eleve .present", (e) ->
    e.stopPropagation()
    $(this).toggle()
    $(this).siblings( ".absent" ).toggle()
    $( this ).closest( ".eleve" ).removeClass "absent"

  ##################################################################
  #Evt : Quand on clique sur un eleve   
  ##################################################################
  do_it = (id) ->
    for dom in SELECTED_DOMS
      $( ".domaine[data-domaine='#{dom}'] .signifiant:visible" ).each ->
        item = $(this).data "item"
        color = DATA_TEMP[id][dom][item].couleur if DATA_TEMP[id][dom][item].couleur isnt undefined
        $( this ).data "color", color
        $( this ).attr "data-color", color   
  $( "body" ).on "click", ".eleve", ->
    id = $(this).attr "id"
    if $( ".signifiant:not([data-color='white'])" ).length is 0
      alert "Selectionnez d'abord des signifiants !"
    else
      #On selectionne un élève
      if $( ".selected" ).length is 0
        $( this ).addClass "selected"
        do_it(id)
      else
        if $( ".selected" ).is $(this)
          $( ".selected" ).removeClass "selected"
        else 
          $( ".selected" ).removeClass "selected"       
          $( this ).addClass "selected"
          do_it(id)
  ##################################################################
  #Evt : Quand on clique sur Validation 
  ##################################################################    
  $( "body" ).on "click", "#validEval", -> 
    $( this ).after "<button id='validAllCancel' class='button red'>Annuler</button><button id='validAll' class='button green'>Tout valider</button>"
    $( "#validEval" ).hide()
  
  $( "body" ).on "click", "#validAllCancel", -> 
    $( "#validEval" ).show()
    $( "#validAll, #validAllCancel" ).remove()
    
  $( "body" ).on "click", "#validAll", -> 
    if confirm('Êtes-vous sur de vouloir tout valider ?')
      for id of DATA_TEMP
        nom    = $( "##{id}" ).data "nom"
        prenom = $( "##{id}" ).data "prenom"
        for dom in SELECTED_DOMS
          $( ".domaine[data-domaine='#{dom}'] .signifiant:visible" ).each -> 
            item = $(this).data "item"
            if $( "##{id}" ).hasClass "absent"
              note = "ABS"
            else
              if DATA_TEMP[id][dom][item].note > 0
                note = DATA_TEMP[id][dom][item].note
              else
                note = "NE"
            DATA.push [new Date(), id, CURRENT_CLASSE, nom, prenom, dom, item, note]
      localStorage.DATA = JSON.stringify(DATA)
      options= {"separator" : "\t"}
      $( "#clipboard" ).text( $.csv.fromArrays DATA, options )
      new Clipboard "#copy"     
      $( "#copy" ).click()
      alert "Prêt à coller dans un tableur (ctrl+V) !"  
  ##################################################################
  #Evt : Mode QrCode START
  ##################################################################    
  $( "body" ).on "click", "#qrcodeModeStart", ->
    $( ".signifiant:visible:first" ).addClass "selectedSig"
    $( ".eleve" ).hide()
    $( "body" ).off "click", ".signifiant"
    $( "body" ).on "click", ".signifiant", ->
      $( ".selectedSig" ).removeClass "selectedSig"
      $(this).addClass "selectedSig"      
    $( "#qrcodeModeStart, #qrcodeModeStop" ).toggle()
    $( "#scanner" ).show()
    

    $('#reader').html5_qrcode ((data) ->
      $( ".eleve" ).hide()    
      [id, color] = data.split("-")
      $( "##{id}.eleve" ).show()
      do_it(id)
      dom  = $( ".selectedSig" ).data "domaine"
      item = $( ".selectedSig" ).data "item"
      #console.log "id:#{id}, color:#{color}, dom:#{dom}, item:#{item}"
      $( ".selectedSig" ).data "color", color
      $( ".selectedSig" ).attr "data-color", color
      $( "##{id}.eleve .eval_sig[data-item='#{item}']" ).data "color", color
      $( "##{id}.eleve .eval_sig[data-item='#{item}']" ).attr "data-color", color
      score = {"shaded": 0, "red": 10, "yellow": 25, "green":40, "lightGreen":50}[color]
      DATA_TEMP[id][dom][item] = 
        note       : score
        couleur    : color
    ), ((error)     -> console.log "#read_error : #{error}"
    ), (videoError) -> console.log "#vid_error : #{videoError}"  
  ##################################################################
  #Evt : Mode QrCode STOP
  ##################################################################  
  $( "body" ).on "click", "#qrcodeModeStop", ->
    $( ".selectedSig" ).removeClass "selectedSig"
    $( "#qrcodeModeStart, #qrcodeModeStop" ).toggle()
    $( "#cam, #qr-canvas" ).remove()
    $( "#scanner" ).hide()
    $( "body" ).off "click", ".signifiant"
    $( "body" ).on "click", ".signifiant", -> toggleSignifiant( $(this).data "item" )
    $( ".eleve" ).hide()
    $( ".eleve[data-classe='#{CURRENT_CLASSE}']" ).show()
      
  






















