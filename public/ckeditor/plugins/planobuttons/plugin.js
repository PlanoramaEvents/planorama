/**
 */

CKEDITOR.plugins.add('planobuttons', {
  requires: ['menubutton'],
  init : function(editor) {
    var buttonsConfig = editor.config.planobuttons,
      plugin = this;
    if (!buttonsConfig)
      return;

    function createCommand(definition) {
      return {
        exec: function(editor) {
          var strToLook = '> </',
            code = definition.html;

          // Check to see if we have selected text:
          var sel = editor.getSelection(),
            selectedText = sel && sel.getSelectedText();

          if (code.indexOf(strToLook) != -1 && selectedText) {
            // Build list of block elements to be replaced
            var blockElems=['address','article','aside','audio','blockquote','canvas','dd','div','dl','fieldset',
              'figcaption','figure','figcaption','footer','form','h1','h2','h3','h4','h5','h6','header','hgroup',
              'hr','noscript','ol','output','p','pre','section','table','tfoot','ul','video'];

            // Get HTML and Text from selection
            var ranges = sel.getRanges();
            var el = new CKEDITOR.dom.element( 'div' );
            for (var i = 0, len = ranges.length; i < len; ++i) {
              var range = ranges[ i],
                bookmark = range.createBookmark2();

              el.append( range.cloneContents() );
              range.moveToBookmark( bookmark );
              range.select();
            }
            var selectedHtml = el.getHtml();

            // Replace block elements from html
            for (var i = 0; i < blockElems.length; i++) {
              var pattern = '(<' + blockElems[i] + '[^>]*>|<\/' + blockElems[i] + '>)';
              var re = new RegExp(pattern, 'gi');
              selectedHtml = selectedHtml.replace(re, '');
            }

            // Do the actual replacing
            code = code.replace(strToLook, '>' + selectedHtml + '</');
          }

          editor.insertHtml(code);
        }
      };
    }

    function createMenuButton(definition) {
      var itemsConfig = definition.items;
      var items = {};

      // add menuitem from config.itemlist
      for (var i = 0; i < itemsConfig.length; i++ ) {
        var item = itemsConfig[ i ];
        var commandName = item.name;
        editor.addCommand( commandName, createCommand( item ) );

        items[commandName] = {
          label: item.title,
          command : commandName,
          group: definition.name,
          role: 'menuitem'
        };
      }
      editor.addMenuGroup( definition.name, 1 );
      editor.addMenuItems( items );

      return {
        label: definition.title,
        icon: plugin.path + definition.icon,
        toolbar: definition.toolbar || 'insert',
        className: 'plono-ck-button',
        onMenu: function() {
          var activeItems = {};

          for (var item in items) {
            activeItems[ item ] = CKEDITOR.TRISTATE_OFF;
          }

          return activeItems;
        }
      };
    }

    // Create the command for each button
    for (var i = 0; i < buttonsConfig.length; i++) {
      var definition = buttonsConfig[ i ];
      var commandName = definition.name;
      if (definition.html) {
        editor.addCommand(commandName, createCommand(definition));

        editor.ui.addButton(commandName, {
          label : definition.title,
          command : commandName,
          align: 'left'
        });
      } else {
        // create a menubutton
        var menuButton = createMenuButton( definition );
        editor.ui.add( commandName,  CKEDITOR.UI_MENUBUTTON, menuButton);
      }
    }
  } //Init
});

/**
 */

CKEDITOR.config.planobuttons = [
  {
    name:'insert-plano-email-fields',
    title:'Wstaw pole łączenia emaili',
    align: 'left',
    items : [
      {
        name:'fullname',
        html:'<%= person.name %>',
        title:'Imię i nazwisko osoby'
      },
      {
        name:'pubname',
        html:'<%= person.published_name %>',
        title:'Publikowane imię osoby'
      },
      {
        name:'email',
        html:'<%= person.email %>',
        title:'Główny adres email osoby'
      },
      {
        name:'participant_schedule_url',
        html:'<%= participant_schedule_url %>',
        title:'URL harmonogramu uczestnika'
      },
      {
        name:'survey_name',
        html:'<%= survey.name %>',
        title:'Nazwa ankiety'
      },
      {
        name:'survey_url',
        html:'<%= survey_url %>',
        title:'URL ankiety'
      },
      {
        name:'login_url',
        html:'<%= login_url %>',
        title:'URL logowania'
      },
      {
        name:'participant_schedule',
        html:'<%= schedule_to_html %>',
        title:'Harmonogram uczestnika'
      }
    ]
  }
];