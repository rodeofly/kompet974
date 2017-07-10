// Generated by CoffeeScript 1.9.3
(function() {
  var CLASSES, CURRENT_CLASSE, CURRENT_EVAL, DATA, DATA_TEMP, DOMAINES, Descripteur, DnDFileController, Domaine, Eleve, HEADERS, ID, MediaStream, SELECTED_DOMS, STUDENTS, STUDENT_ID, Signifiant, TREE_EVAL, copyToClipboard, d3, studentsCards, timer,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  ID = 1000;

  STUDENT_ID = 1;

  HEADERS = ['ID', 'Classe', 'Nom', 'Prénom'];

  SELECTED_DOMS = [];

  DOMAINES = void 0;

  CLASSES = [];

  DATA = [];

  DATA_TEMP = {};

  STUDENTS = {};

  TREE_EVAL = {};

  CURRENT_EVAL = {};

  CURRENT_CLASSE = void 0;

  MediaStream = window.MediaStream;

  if (typeof MediaStream === 'undefined' && typeof webkitMediaStream !== 'undefined') {
    MediaStream = webkitMediaStream;
  }

  timer = function(name) {
    var start;
    start = new Date();
    return {
      stop: function() {
        var end, time;
        end = new Date();
        time = end.getTime() - start.getTime();
        return console.log('Timer:', name, 'finished in', time, 'ms');
      }
    };
  };

  Eleve = (function() {
    function Eleve(classe, nom1, prenom1) {
      this.classe = classe;
      this.nom = nom1;
      this.prenom = prenom1;
      this.id = STUDENT_ID++;
      this.evaluation = {};
      this.html = "<div id=\"" + this.id + "\" class=\"eleve\" data-classe=\"" + this.classe + "\" data-nom=\"" + this.nom + "\" data-prenom=\"" + this.prenom + "\">\n  <div class=\"content\">\n    <button class='absent button black'>" + this.classe + " - Présent</button>\n    <button class='present button white' style='display:none;'>" + this.classe + " - Absent</button>\n    <button class='save button red' style='display:none;'>Valider</button>   \n    <div class=\"evaluation\"></div>\n    <h1>" + this.nom + " " + this.prenom + "</h1>\n    \n  </div>\n</div>";
    }

    return Eleve;

  })();

  Descripteur = (function() {
    function Descripteur(descripteur1, item1, signifiantItem) {
      this.descripteur = descripteur1;
      this.item = item1;
      this.signifiantItem = signifiantItem;
      this.id = ID++;
      this.html = "<li id='" + this.id + "' class='descripteur' data-descripteur='" + this.descripteur + "' data-item='" + this.item + "' data-signifiant-item='" + this.signifiantItem + "' data-color='white'>\n    <div class='head'>" + this.descripteur + "</div>\n</li>";
    }

    return Descripteur;

  })();

  Signifiant = (function() {
    function Signifiant(signifiant1, item1, domaine) {
      this.signifiant = signifiant1;
      this.item = item1;
      this.domaine = domaine;
      this.id = ID++;
      this.html = "<div id='" + this.id + "' class='signifiant' data-item='" + this.item + "' data-color='white' data-signifiant='" + this.signifiant + "' data-domaine='" + this.domaine + "'>\n    <div class='head'>\n        <button class='toggleDescripteurs button black hide' data-id='" + this.id + "'>[Détails]</button> " + this.signifiant + "\n    </div>\n    <div class='descripteurs'>\n        <ul></ul>\n    </div>\n</div>";
    }

    return Signifiant;

  })();

  Domaine = (function() {
    function Domaine(domaine, desc, iconUrl) {
      this.domaine = domaine;
      this.desc = desc;
      this.iconUrl = iconUrl;
      this.id = ID++;
      this.htmlTab = "<div class='domaine__tab hide' data-id='" + this.id + "' data-domaine='" + this.domaine + "'>\n    <div class='head'>\n        <img class='domaine__icon' src='" + this.iconUrl + "'>\n    </div>\n</div>";
      this.html = "<div id='" + this.id + "' class='domaine' data-domaine='" + this.domaine + "' data-description='" + this.desc + "' data-icon='" + this.iconUrl + "'>\n    <div class='head'>  \n        <img class='domaine__icon' src='" + this.iconUrl + "' data-domaine='" + this.domaine + "'>\n        \n        \n        <button class='toggleDomDescription button black hide' data-id='" + this.id + "'>info</button> \n        <div class=\"domDescription\" style=\"display:none;\"><div class='domaine__name'>" + this.domaine + " : " + this.desc + "</div></div>\n    </div>\n    <div class='signifiants'></div>\n</div>";
    }

    return Domaine;

  })();

  DnDFileController = function(selector, onDropCallback) {
    var el_;
    el_ = document.querySelector(selector);
    this.dragenter = function(e) {
      e.stopPropagation();
      e.preventDefault();
      el_.classList.add('dropping');
      return $("#upload").addClass("slim");
    };
    this.dragover = function(e) {
      e.stopPropagation();
      return e.preventDefault();
    };
    this.dragleave = function(e) {
      e.stopPropagation();
      e.preventDefault();
      $("#upload").removeClass("slim");
      return el_.classList.remove('dropping');
    };
    this.drop = function(e) {
      e.stopPropagation();
      e.preventDefault();
      el_.classList.remove('dropping');
      onDropCallback(e.dataTransfer.files, e);
      $("#upload").removeClass("slim");
      return $("#upload").hide();
    };
    el_.addEventListener('dragenter', this.dragenter, false);
    el_.addEventListener('dragover', this.dragover, false);
    el_.addEventListener('dragleave', this.dragleave, false);
    return el_.addEventListener('drop', this.drop, false);
  };

  copyToClipboard = function(el) {
    var body, e, range, sel;
    body = document.body;
    if (document.createRange && window.getSelection) {
      range = document.createRange();
      sel = window.getSelection();
      sel.removeAllRanges();
      try {
        range.selectNodeContents(el);
        sel.addRange(range);
      } catch (_error) {
        e = _error;
        range.selectNode(el);
        sel.addRange(range);
      }
    } else if (body.createTextRange) {
      range = body.createTextRange();
      range.moveToElementText(el);
      range.select();
    }
    return document.execCommand("Copy");
  };

  studentsCards = function(data) {
    var array, k, len, ref, results, s, students_arrays;
    CLASSES = [];
    $("#eleves").empty();
    students_arrays = $.csv.toArrays(data);
    results = [];
    for (k = 0, len = students_arrays.length; k < len; k++) {
      array = students_arrays[k];
      s = new Eleve(array[0], array[1], array[2]);
      STUDENTS[s.id] = s;
      if (ref = s.classe, indexOf.call(CLASSES, ref) < 0) {
        CLASSES.push(s.classe);
      }
      results.push($("#eleves").append(s.html));
    }
    return results;
  };

  d3 = $.Deferred();

  $.fn.extend({
    html5_qrcode: function(qrcodeSuccess, qrcodeError, videoError) {
      return this.each(function() {
        var audioSelect, canvas, canvasElem, context, currentElem, getStream, gotDevices, gotStream, handleError, height, localMediaStream, scan, vidElem, video, videoSelect, width;
        currentElem = $(this);
        height = currentElem.height();
        width = currentElem.width();
        if (height === null) {
          height = 250;
        }
        if (width === null) {
          width = 300;
        }
        vidElem = $("<video id='cam' width='" + width + "px' height='" + height + "px'></video>").appendTo(currentElem);
        canvasElem = $("<canvas id='qr-canvas' width='" + (width - 2) + "px' height='" + (height - 2) + "px' style='display:none;'></canvas>").appendTo(currentElem);
        video = vidElem[0];
        canvas = canvasElem[0];
        context = canvas.getContext('2d');
        localMediaStream = void 0;
        audioSelect = document.querySelector('select#audioSource');
        videoSelect = document.querySelector('select#videoSource');
        scan = function() {
          var e;
          if (localMediaStream) {
            context.drawImage(video, 0, 0, 307, 250);
            try {
              qrcode.decode();
            } catch (_error) {
              e = _error;
              qrcodeError(e, localMediaStream);
            }
            return $.data(currentElem[0], 'timeout', setTimeout(scan, 500));
          } else {
            return $.data(currentElem[0], 'timeout', setTimeout(scan, 500));
          }
        };
        gotDevices = function(deviceInfos) {
          var deviceInfo, i, option;
          i = 0;
          while (i !== deviceInfos.length) {
            deviceInfo = deviceInfos[i];
            option = document.createElement('option');
            option.value = deviceInfo.deviceId;
            if (deviceInfo.kind === 'audioinput') {
              option.text = deviceInfo.label || 'microphone ' + audioSelect.length + 1;
              audioSelect.appendChild(option);
            } else if (deviceInfo.kind === 'videoinput') {
              option.text = deviceInfo.label || 'camera ' + videoSelect.length + 1;
              videoSelect.appendChild(option);
            } else {
              console.log('Found ome other kind of source/device: ', deviceInfo);
            }
            ++i;
          }
        };
        getStream = function() {
          var constraints;
          if (window.stream) {
            window.stream.getTracks().forEach(function(track) {
              track.stop();
            });
          }
          constraints = {
            audio: {
              optional: [
                {
                  sourceId: audioSelect.value
                }
              ]
            },
            video: {
              optional: [
                {
                  sourceId: videoSelect.value
                }
              ]
            }
          };
          navigator.mediaDevices.getUserMedia(constraints).then(gotStream)["catch"](handleError);
        };
        gotStream = function(stream) {
          window.stream = stream;
          video.srcObject = stream;
          localMediaStream = stream;
          $.data(currentElem[0], 'stream', stream);
          video.play();
          return $.data(currentElem[0], 'timeout', setTimeout(scan, 1000));
        };
        handleError = function(error) {
          return console.log('Error: ', error);
        };
        if (navigator.getUserMedia) {
          navigator.mediaDevices.enumerateDevices().then(gotDevices).then(getStream)["catch"](handleError);
          audioSelect.onchange = getStream;
          videoSelect.onchange = getStream;
        } else {
          console.log('Native web camera streaming (getUserMedia) not supported in this browser.');
        }
        return qrcode.callback = function(result) {
          return qrcodeSuccess(result, localMediaStream);
        };
      });
    },
    html5_qrcode_stop: function() {
      return this.each(function() {
        $(this).data('stream').getVideoTracks().forEach(function(videoTrack) {
          videoTrack.stop();
        });
        return clearTimeout($(this).data('timeout'));
      });
    }
  });

  $(function() {
    var d1, d2, dnd, do_it, toggleSignifiant;
    $("#upload .close").on("click", function() {
      return $("#upload").hide();
    });
    window.onbeforeunload = function() {
      return "";
    };
    d1 = $.Deferred();
    d2 = $.Deferred();
    $.ajax({
      type: "GET",
      url: "eleves.csv",
      dataType: "text",
      success: function(data) {
        return studentsCards(data);
      }
    });
    $("#eleves").hide();
    d1.resolve("Éleves finished !");
    $.getJSON("S4C_cat.json", function(data) {
      var des, descripteur, descripteurs, dom, i, j, k, len, nom, ref, sig, signifiant;
      DOMAINES = data;
      for (nom in DOMAINES) {
        CURRENT_EVAL[nom] = {};
        dom = new Domaine(nom, data[nom].description, data[nom].iconUrl);
        $("#tabs").append(dom.htmlTab);
        $("#domaines_area").append(dom.html);
        i = 1;
        ref = data[nom].signifiants;
        for (signifiant in ref) {
          descripteurs = ref[signifiant];
          sig = new Signifiant(signifiant, nom + "." + (i++), dom.domaine);
          $(".domaine[data-domaine='" + sig.domaine + "']").find(".signifiants").append(sig.html);
          j = 1;
          for (k = 0, len = descripteurs.length; k < len; k++) {
            descripteur = descripteurs[k];
            des = new Descripteur(descripteur, sig.item + "." + (j++), sig.item);
            $(".signifiant[data-item='" + sig.item + "'] .descripteurs ul").append(des.html);
          }
        }
      }
      $("#edit").prop("checked", false);
      $(".toggleDescripteurs").click();
      $(".domaine, .domaine__tab").hide();
      return d2.resolve("S4C finished !");
    });
    $.when(d1, d2).done(function(v1, v2) {
      var $select, k, len, o, ref;
      console.log(v1);
      console.log(v2);
      $select = $("<select id='mainselect'><option value='defaut'>&#9776;</option></select>");
      ref = ["Importer", "Charger Local", "Effacer Local", "Imprimer les QR-codes", "Copier"].concat(CLASSES);
      for (k = 0, len = ref.length; k < len; k++) {
        o = ref[k];
        $select.append("<option value='" + o + "'>" + o + "</option>");
      }
      $("#tabs").prepend($select);
      $("#mainselect option[value=Menu]").prop("selected", true);
      return $("#mainselect").change(function() {
        var $html, $nom, $qrcode, i, j, l, len1, m, note, option, options, ref1, save;
        save = function(type) {
          var dataStr, dlAnchorElem, options, stringValue;
          dataStr = "data:text/" + type + ";charset=utf-8,";
          stringValue = prompt("Nom du fichier ?", stringValue);
          switch (type) {
            case "json":
              dataStr += encodeURIComponent(JSON.stringify(DOMAINES));
              break;
            case "csv":
              options = {
                "separator": "\t"
              };
              dataStr += encodeURIComponent($.csv.fromArrays(DATA_TEMP, options));
          }
          dlAnchorElem = document.getElementById('save');
          dlAnchorElem.setAttribute("href", dataStr);
          dlAnchorElem.setAttribute("download", stringValue + "." + type);
          return dlAnchorElem.click();
        };
        option = $("#mainselect").val();
        switch (option) {
          case "Importer":
            $("#upload").show();
            break;
          case "Charger Local":
            if (localStorage.DATA) {
              DATA = JSON.parse(localStorage.DATA);
              console.log(DATA);
              alert("Nous avons retrouvé " + DATA.length + " entrée(s) dans le navigateurs :)");
            } else {
              DATA = [];
              alert("Nous n'avons retrouvé aucune entrée dans le navigateurs :(");
            }
            break;
          case "Effacer Local":
            if (confirm('Êtes-vous sur de vouloir tout effacer ?')) {
              localStorage.DATA = [];
            }
            break;
          case "Imprimer les QR-codes":
            if (STUDENT_ID === 1) {
              alert("importer des élèves d'abord !");
            } else {
              $html = $("<div class='qrcodes'></div>");
              note = {
                "shaded": "NE",
                "red": "insuffisant",
                "yellow": "fragile",
                "lightGreen": "satisfaisant",
                "green": "très bien"
              };
              for (i = l = 1; l <= 25; i = ++l) {
                $nom = $("<div class='grid'><h3>" + i + "-" + STUDENTS[i].nom + " " + STUDENTS[i].prenom + "</h3></div>");
                ref1 = ["shaded", "red", "yellow", "lightGreen", "green"];
                for (m = 0, len1 = ref1.length; m < len1; m++) {
                  j = ref1[m];
                  $qrcode = $("<div class='qrcodePrint'/>");
                  $qrcode.qrcode({
                    width: 128,
                    height: 128,
                    text: i + "-" + j
                  });
                  $nom.append($qrcode.append("<br><span>" + note[j] + "</span>"));
                  $html.append($nom);
                }
              }
              $("body").empty().append($html);
            }
            break;
          case "Sauver Table":
            save("csv");
            break;
          case "Sauver Catégories":
            save("json");
            break;
          case "Copier":
            options = {
              "separator": "\t"
            };
            $("#clipboard").text($.csv.fromArrays(DATA, options));
            new Clipboard("#copy");
            $("#copy").click();
            break;
          default:
            CURRENT_CLASSE = option;
            $("#eleves").show();
            $(".eleve:not([data-classe='" + option + "']) ").hide();
            $(".eleve[data-classe='" + option + "'] ").show();
            $("#editEval").show();
        }
        return $("#mainselect option[value='defaut']").prop("selected", true);
      });
    });
    dnd = new DnDFileController('#upload', function(files) {
      var f, reader;
      f = files[0];
      reader = new FileReader;
      reader.onloadend = function(e) {
        return studentsCards(this.result);
      };
      reader.readAsText(f);
    });
    $("body").on("click", "input[data-row='0']", function() {
      var checkBoxes;
      checkBoxes = $("input[type='checkbox']").not($(this));
      if ($(this).prop("checked")) {
        return checkBoxes.prop("checked", true).closest("tr").addClass("export");
      } else {
        return checkBoxes.prop("checked", false).closest("tr").removeClass("export");
      }
    });
    $("body").on("click", ".domaine__tab", function(event) {
      var dom, id, index;
      id = $(this).data("id");
      dom = $(this).data("domaine");
      $(this).toggleClass("show hide");
      if ($(this).hasClass("show")) {
        return $("#" + id + ", #" + id + " .signifiants, #" + id + " .signifiant").show();
      } else {
        index = SELECTED_DOMS.indexOf(dom);
        if (index > -1) {
          SELECTED_DOMS.splice(index, 1);
        }
        return $("#" + id).hide();
      }
    });
    $("body").on("click", ".toggleDomDescription", function(event) {
      var id;
      id = $(this).data("id");
      return $("#" + id + " .domDescription").toggle();
    });
    toggleSignifiant = function(item) {
      var $s, color, dom, id, ref, ref1, ref2, ref3, ref4, ref5, ref6, score;
      $s = $(".signifiant[data-item='" + item + "']");
      dom = $s.data("domaine");
      color = $s.data("color");
      switch (color) {
        case "white":
          ref = ["shaded", 0], color = ref[0], score = ref[1];
          break;
        case "shaded":
          ref1 = ["red", 10], color = ref1[0], score = ref1[1];
          break;
        case "red":
          ref2 = ["yellow", 25], color = ref2[0], score = ref2[1];
          break;
        case "yellow":
          ref3 = ["lightGreen", 40], color = ref3[0], score = ref3[1];
          break;
        case "lightGreen":
          ref4 = ["green", 50], color = ref4[0], score = ref4[1];
          break;
        case "green":
          if ($("#domaines_area .domaine[data-domaine='" + dom + "']").hasClass("freeze")) {
            ref5 = ["shaded", 0], color = ref5[0], score = ref5[1];
          } else {
            ref6 = ["white", 0], color = ref6[0], score = ref6[1];
          }
      }
      $s.attr("data-color", color);
      $s.data("color", color);
      CURRENT_EVAL[dom][item] = {
        note: score,
        couleur: color
      };
      if ($("#domaines_area .domaine[data-domaine='" + dom + "']").hasClass("freeze")) {
        if ($(".selected").length > 0) {
          id = $(".selected").attr("id");
          $(".selected .eval_sig[data-item='" + item + "']").data("color", color);
          $(".selected .eval_sig[data-item='" + item + "']").attr("data-color", color);
          return DATA_TEMP[id][dom][item] = {
            note: score,
            couleur: color
          };
        }
      } else {
        if (color !== "white") {
          $("#freeze").show();
          if (indexOf.call(SELECTED_DOMS, dom) < 0) {
            SELECTED_DOMS.push(dom);
          }
          SELECTED_DOMS.sort();
          return $(".eleve[data-classe='" + CURRENT_CLASSE + "']").each(function() {
            id = $(this).attr("id");
            if (DATA_TEMP[id] === void 0) {
              DATA_TEMP[id] = {};
            }
            if (DATA_TEMP[id][dom] === void 0) {
              DATA_TEMP[id][dom] = {};
            }
            if (DATA_TEMP[id][dom][item] === void 0) {
              return DATA_TEMP[id][dom][item] = {};
            }
          });
        } else {
          if ($(".signifiant:not([data-color='white'])").length === 0) {
            return $("#freeze").hide();
          }
        }
      }
    };
    $("body").on("click", ".signifiant", function() {
      return toggleSignifiant($(this).data("item"));
    });
    $("body").on("click", ".toggleDescripteurs", function(event) {
      var id;
      event.stopPropagation();
      id = $(this).data("id");
      $(this).toggleClass("hide show");
      return $("#" + id + " .descripteurs").toggle();
    });
    $("body").on("click", "#editEval", function() {
      var dom, k, len, results;
      if (CURRENT_CLASSE === void 0) {
        return alert("selectionner une classe");
      } else {
        $(this).hide();
        $("#eleves, #validEval, #qrcodeModeStart").hide();
        $(".domaine__tab").show();
        if ($(".signifiant:not([data-color='white'])").length > 0) {
          $("#freeze").show();
        }
        results = [];
        for (k = 0, len = SELECTED_DOMS.length; k < len; k++) {
          dom = SELECTED_DOMS[k];
          $(".domaine[data-domaine='" + dom + "'], .domaine[data-domaine='" + dom + "'] .signifiant").show();
          $(".domaine[data-domaine='" + dom + "'], #domaines_area").removeClass("freeze");
          results.push($(".signifiant[data-descripteur='" + dom + "']").attr("data-color", "shaded").data("color", "shaded"));
        }
        return results;
      }
    });
    $("body").on("click", "#freeze", function() {
      var $html, d, dom, id, k, l, len, len1, len2, m, ref, s, signifiants, t1, t2;
      $("#qrcodeModeStart").show();
      $(".domaine__tab, .signifiant[data-color='white']").hide();
      $(this).hide();
      $("#eleves, #editEval, #validEval").show();
      $("#domaines_area").addClass("freeze");
      $html = $("<div/>");
      t1 = timer('First loop');
      for (k = 0, len = SELECTED_DOMS.length; k < len; k++) {
        d = SELECTED_DOMS[k];
        $(".domaine[data-domaine='" + d + "']").addClass("freeze");
        $html.append("<div class='eval_dom' data-domaine='" + d + "'></div>");
        signifiants = Object.keys(CURRENT_EVAL[d]);
        ref = signifiants.sort();
        for (l = 0, len1 = ref.length; l < len1; l++) {
          s = ref[l];
          if (CURRENT_EVAL[d][s].couleur !== "white") {
            $html.find(".eval_dom[data-domaine='" + d + "']").append("<div class='eval_sig' data-item='" + s + "' data-color='" + CURRENT_EVAL[d][s].couleur + "' data-note='" + CURRENT_EVAL[d][s].note + "'></div>");
          }
        }
      }
      t1.stop();
      $(".domaine").filter(":not(.freeze)").hide();
      $(".eleve[data-classe='" + CURRENT_CLASSE + "'] .evaluation").empty();
      $(".eleve[data-classe='" + CURRENT_CLASSE + "']").find(".evaluation").append($html.html());
      t2 = timer('Second loop');
      for (id in DATA_TEMP) {
        for (m = 0, len2 = SELECTED_DOMS.length; m < len2; m++) {
          dom = SELECTED_DOMS[m];
          $(".domaine[data-domaine='" + dom + "'] .signifiant:not([data-color='white'])").each(function() {
            var color, item;
            item = $(this).data("item");
            if (DATA_TEMP[id][dom][item].couleur !== void 0) {
              $("#" + id + " .eval_sig[data-item='" + item + "']").data("color", DATA_TEMP[id][dom][item].couleur);
              return $("#" + id + " .eval_sig[data-item='" + item + "']").attr("data-color", DATA_TEMP[id][dom][item].couleur);
            } else {
              color = $(this).data("color");
              $("#id .eval_sig[data-item='" + item + "']").data("color", color);
              $("#id .eval_sig[data-item='" + item + "']").attr("data-color", color);
              return DATA_TEMP[id][dom][item].couleur = color;
            }
          });
        }
      }
      return t2.stop();
    });
    $("body").on("click", ".eleve .absent", function(e) {
      e.stopPropagation();
      $(this).toggle();
      $(this).siblings(".present").toggle();
      return $(this).closest(".eleve").addClass("absent");
    });
    $("body").on("click", ".eleve .present", function(e) {
      e.stopPropagation();
      $(this).toggle();
      $(this).siblings(".absent").toggle();
      return $(this).closest(".eleve").removeClass("absent");
    });
    do_it = function(id) {
      var dom, k, len, results;
      results = [];
      for (k = 0, len = SELECTED_DOMS.length; k < len; k++) {
        dom = SELECTED_DOMS[k];
        results.push($(".domaine[data-domaine='" + dom + "'] .signifiant:visible").each(function() {
          var color, item;
          item = $(this).data("item");
          if (DATA_TEMP[id][dom][item].couleur !== void 0) {
            color = DATA_TEMP[id][dom][item].couleur;
          }
          $(this).data("color", color);
          return $(this).attr("data-color", color);
        }));
      }
      return results;
    };
    $("body").on("click", ".eleve", function() {
      var id;
      id = $(this).attr("id");
      if ($(".signifiant:not([data-color='white'])").length === 0) {
        return alert("Selectionnez d'abord des signifiants !");
      } else {
        if ($(".selected").length === 0) {
          $(this).addClass("selected");
          return do_it(id);
        } else {
          if ($(".selected").is($(this))) {
            return $(".selected").removeClass("selected");
          } else {
            $(".selected").removeClass("selected");
            $(this).addClass("selected");
            return do_it(id);
          }
        }
      }
    });
    $("body").on("click", "#validEval", function() {
      $(this).after("<button id='validAllCancel button red'>Annuler</button><button id='validAll'>Tout valider</button>");
      return $(this).remove();
    });
    $("body").on("click", "#validAllCancel", function() {
      $(this).after("<button id='validEval button red'>Validation</button>");
      $(this).remove();
      return $("#validAll").remove();
    });
    $("body").on("click", "#validAll", function() {
      var dom, id, k, len, nom, options, prenom;
      if (confirm('Êtes-vous sur de vouloir tout valider ?')) {
        for (id in DATA_TEMP) {
          nom = $("#" + id).data("nom");
          prenom = $("#" + id).data("prenom");
          for (k = 0, len = SELECTED_DOMS.length; k < len; k++) {
            dom = SELECTED_DOMS[k];
            $(".domaine[data-domaine='" + dom + "'] .signifiant:visible").each(function() {
              var item, note;
              item = $(this).data("item");
              if ($("#" + id).hasClass("absent")) {
                note = "ABS";
              } else {
                if (DATA_TEMP[id][dom][item].note > 0) {
                  note = DATA_TEMP[id][dom][item].note;
                } else {
                  note = "NE";
                }
              }
              return DATA.push([new Date(), id, CURRENT_CLASSE, nom, prenom, dom, item, note]);
            });
          }
        }
        localStorage.DATA = JSON.stringify(DATA);
        options = {
          "separator": "\t"
        };
        $("#clipboard").text($.csv.fromArrays(DATA, options));
        new Clipboard("#copy");
        $("#copy").click();
        return alert("Prêt à coller dans un tableur (ctrl+V) !");
      }
    });
    $("body").on("click", "#qrcodeModeStart", function() {
      $(".signifiant:visible:first").addClass("selectedSig");
      $(".eleve").hide();
      $("body").off("click", ".signifiant");
      $("body").on("click", ".signifiant", function() {
        $(".selectedSig").removeClass("selectedSig");
        return $(this).addClass("selectedSig");
      });
      $("#qrcodeModeStart, #qrcodeModeStop").toggle();
      $("#scanner").show();
      return $('#reader').html5_qrcode((function(data) {
        var color, dom, id, item, ref, score;
        $(".eleve").hide();
        ref = data.split("-"), id = ref[0], color = ref[1];
        $("#" + id + ".eleve").show();
        do_it(id);
        dom = $(".selectedSig").data("domaine");
        item = $(".selectedSig").data("item");
        $(".selectedSig").data("color", color);
        $(".selectedSig").attr("data-color", color);
        $("#" + id + ".eleve .eval_sig[data-item='" + item + "']").data("color", color);
        $("#" + id + ".eleve .eval_sig[data-item='" + item + "']").attr("data-color", color);
        score = {
          "shaded": 0,
          "red": 10,
          "yellow": 25,
          "green": 40,
          "lightGreen": 50
        }[color];
        return DATA_TEMP[id][dom][item] = {
          note: score,
          couleur: color
        };
      }), (function(error) {
        return console.log("#read_error : " + error);
      }), function(videoError) {
        return console.log("#vid_error : " + videoError);
      });
    });
    return $("body").on("click", "#qrcodeModeStop", function() {
      $(".selectedSig").removeClass("selectedSig");
      $("#qrcodeModeStart, #qrcodeModeStop").toggle();
      $("#cam, #qr-canvas").remove();
      $("#scanner").hide();
      $("body").off("click", ".signifiant");
      $("body").on("click", ".signifiant", function() {
        return toggleSignifiant($(this).data("item"));
      });
      $(".eleve").hide();
      return $(".eleve[data-classe='" + CURRENT_CLASSE + "']").show();
    });
  });

}).call(this);
