define 'app', [
	'jquery'
	'director'
	'highlight'
	'highlight/languages/xml'
], ($,Director,Highlight)->
	class App
		constructor: ->
			@editor=CodeMirror.fromTextArea document.getElementById("code"),
				lineNumbers: true
				matchBrackets: true
				theme: "xq-light"
			$("button").click @execute
			$("a.example").click @example
			$('code').closest('.row-fluid').hide()

			$("a.example").first().click()
		execute: (event)=>
			$('button').addClass('disabled')
			$('code').closest('.row-fluid').hide()
			$.post '/execute', query: @editor.getValue(), (res)=>
				console.log res.error.length
				if res.error.length!=0
					$('#error').text res.error.replace /\n/g,"\n"
					$('#error').closest('.row-fluid').show()
				else
					$('#result').text res.output.replace /\n/g,"\n"
					Highlight.highlightBlock(document.getElementById("result"))
					$('#result').closest('.row-fluid').show()
				$('button').removeClass('disabled')
			false
		example: (event)=>
			@editor.setValue($(event.currentTarget).next().text())
			@execute()
			true

	new App
