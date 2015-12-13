{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'transformador:upperCase': => @upperCase()
      'transformador:wordInvert': => @wordInvert()
      'transformador:wordReverse': => @wordReverse()
      'transformador:calculate': => @calculate()
      'transformador:wordWave': => @wordWave()
      'transformador:camelCase': => @camelCase()
      'transformador:underscoreCase': => @underscoreCase()
      'transformador:wordShuffle': => @wordShuffle()

  deactivate: ->
    @subscriptions.dispose()

  upperCase: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedText()
      upperCaseSelect = selection.toUpperCase()
      editor.insertText(upperCaseSelect)

  wordInvert: ->
    if editor = atom.workspace.getActiveTextEditor()
      selectionBuffer = editor.getSelectedBufferRanges()
      if selectionBuffer.length == 2
        selectionWordOne = editor.getTextInBufferRange(selectionBuffer[0])
        selectionWordTwo = editor.getTextInBufferRange(selectionBuffer[1])
        if selectionBuffer[0].start.row == selectionBuffer[1].start.row
          if selectionBuffer[0].start.column > selectionBuffer[1].start.column
            editor.setSelectedBufferRange(selectionBuffer[0])
            editor.insertText(selectionWordTwo)
            editor.setSelectedBufferRange(selectionBuffer[1])
            editor.insertText(selectionWordOne)
          else
            editor.setSelectedBufferRange(selectionBuffer[1])
            editor.insertText(selectionWordOne)
            editor.setSelectedBufferRange(selectionBuffer[0])
            editor.insertText(selectionWordTwo)
        else
          editor.setSelectedBufferRange(selectionBuffer[1])
          editor.insertText(selectionWordOne)
          editor.setSelectedBufferRange(selectionBuffer[0])
          editor.insertText(selectionWordTwo)

  wordReverse: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedText()
      reverseSelection = selection.split('').reverse().join('')
      editor.insertText(reverseSelection)

  calculate: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedText().replace(/([^0-9+-/*])/g, "")
      aTempNumber = selection.split(/[^0-9]/g)
      aTempOperator = selection.split(/[0-9]/g)
      aNumber = []
      aOperator = []
      result = 0

      fDeleteEmptyCell = (item, array) ->
        if item != ''
          array.push(item)

      fDeleteEmptyCell item, aOperator for item in aTempOperator
      fDeleteEmptyCell item, aNumber for item in aTempNumber

      if aOperator.length > 0 && aNumber.length > 0

        fCalculate = (i, number) ->
          if i == 0
            switch aOperator[0]
              when '+' then result += (parseInt(aNumber[0]) + parseInt(aNumber[1]))
              when '-' then result += (parseInt(aNumber[0]) - parseInt(aNumber[1]))
              when '*' then result += (parseInt(aNumber[0]) * parseInt(aNumber[1]))
              when '/' then result += (parseInt(aNumber[0]) / parseInt(aNumber[1]))
          else
            switch aOperator[i]
              when '+' then result += parseInt(aNumber[i+1])
              when '-' then result -= parseInt(aNumber[i+1])
              when '*' then result *= parseInt(aNumber[i+1])
              when '/' then result /= parseInt(aNumber[i+1])

        fCalculate i, number for number, i in aNumber

        editor.insertText(result + '')

  wordWave: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedText()
      regAlphabet = new RegExp("[a-z]", "gi")
      splitSelection = selection.split('')
      newString = ''
      odd = false

      fConcat = (item) ->

        temp = item.match(regAlphabet)

        if temp == null
          newString += item
        else
          if odd
            newString += temp[0].toUpperCase()
            odd = false
          else
            newString += temp[0].toLowerCase()
            odd = true

      fConcat item for item in splitSelection

      editor.insertText(newString)

  camelCase: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedText()
      splitTempSelection = selection.split(' ')
      splitSelection = []
      firstWord = false
      spacesBefore = ''
      newString = ''

      fDeleteEmptyCell = (item, array) ->

        if item != ''
          array.push(item)
        else
          spacesBefore += ' '

      fDeleteEmptyCell item, splitSelection for item in splitTempSelection

      newString += spacesBefore

      fToUpperCase = (item, index) ->
        if index == 0
          newString += item.toLowerCase()
        else
          newString += (item.charAt(0).toUpperCase() + item.substring(1).toLowerCase())

      fToUpperCase item, index for item, index in splitSelection

      editor.insertText(newString)

  underscoreCase: ->
    if editor = atom.workspace.getActiveTextEditor()
      selection = editor.getSelectedText()
      splitTempSelection = selection.split(' ')
      splitSelection = []
      firstWord = false
      spacesBefore = ''
      newString = ''

      fDeleteEmptyCell = (item, array) ->

        if item != ''
          array.push(item)
        else
          spacesBefore += ' '
          # Case user write : /  cocu_de_la_mort_qui_rt_tyu/

      fDeleteEmptyCell item, splitSelection for item in splitTempSelection

      newString += spacesBefore

      fToUpperCase = (item, index) ->
        if index == 0
          newString += item.toLowerCase()
        else
          newString += ('_' + item.toLowerCase())

      fToUpperCase item, index for item, index in splitSelection

      editor.insertText(newString)

  wordShuffle: ->
      if editor = atom.workspace.getActiveTextEditor()
        selection = editor.getSelectedText()
        splitSelection = selection.split('')
        shuffle = (array) ->
          counter = array.length
          while (counter > 0)
              index = Math.floor(Math.random() * counter);
              counter--;
              temp = array[counter];
              array[counter] = array[index];
              array[index] = temp;
          return array;

        shuffeledWord = (shuffle splitSelection).join('')

        editor.insertText(shuffeledWord)
