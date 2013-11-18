###global window, document, console###

class @StyledSelects
  @selects = []

  # Class methods
  @init: (elements) ->
    if elements instanceof Object
      for element in elements
        @selects.push new @(element, @selects.length)
    else
      @selects.push new @(elements, @selects.length)

    document.addEventListener 'click', @click, false

  @click: (e) =>
    target = e.target

    if target.className is 'styled_select_selected'
      id = target.parentNode.getAttribute('data-styled-select-id')
      @selects[id].selectClicked()
      @closeAllBut(id)

    else if target.className is 'styled_select_option'
      id =  target.
            parentNode.
            parentNode.getAttribute('data-styled-select-id')

      @selects[id].optionClicked(target)
      @closeAllBut(id)

    else
      for select in @selects
        select.closeOptions()

  @closeAllBut: (id) =>
    for i in [0..@selects.length - 1] by 1
      if i != id*1
        @selects[i].closeOptions()

  # Instance methods
  constructor: (el, instanceId) ->
    @el           = el
    @options      = []
    @width        = @el.offsetWidth
    @instanceId   = instanceId
    @open         = false
    @optionsHTML  = ""

    hideOrigional(@el)
    @getOptions()

    @selectedOption = @getSelected()

    @render()

  template: ->
    """
      <section  id="styled_select_#{@el.id}"
                style="width:#{@width}px;"
                data-styled-select-id="#{@instanceId}"
                data-parent-id="#{@el.id}"
                class="styled_select">

        <span class="styled_select_selected">#{@selectedOption.innerHTML}</span>
          <ul class="styled_select_options">
            #{@optionsHTML}
          </ul>
      </section>
    """

  getOptions: ->
    i = 0

    for option in @el.options
      value = option.value
      label = option.innerHTML

      @optionsHTML += @optionTemplate(i, value, label)

      i++

  getSelected: ->
    selected = false

    for option in @el.options
      if option.hasAttribute('selected')
        return option

    return selected if selected

    if @el.hasAttribute('data-placeholder')

      option =
        value: null
        innerHTML: @el.getAttribute('data-placeholder')

      return option

    return @el.options[0]

  setSelected: (index) ->
    document.getElementById(@el.id).selectedIndex = index
    @self.querySelector('span').innerHTML = @el.options[index].innerHTML

  optionTemplate: (index, value, label) ->
    """
      <li class="styled_select_option"
        data-option-index="#{index}"
        data-value="#{value}">
        #{label}
      </li>
    """

  render: ->
    @self = document.createElement('div')

    @self.id        = "styled_select_#{@el.id}"
    @self.className = "styled_select_wrapper"
    @self.innerHTML = @template()

    @self.style.width = @width + 'px'

    @el.parentNode.appendChild @self

  hideOrigional = (el) ->
    el.style.width     = 0
    el.style.height    = 0
    el.style.opacity   = 0
    el.style.margin    = 0
    el.style.padding   = 0

  fireChangeEvent: =>
    if document.createEvent
      event = document.createEvent 'Events'
      event.initEvent 'change', true, false
      @el.dispatchEvent event

    else if document.createEventObject
      @el.fireEvent 'onchange'

    else if typeof @el.onchange == 'function'
      @el.onchange()

  isOpen: ->
    @open

  openOptions: ->
    @open = true
    @self.querySelector('.styled_select').className += " open"

  closeOptions: ->
    @open = false
    el = @self.querySelector('.styled_select')
    el.className = el.className.replace /(\s)?open/, ''

  selectClicked: =>
    if @isOpen()
      @closeOptions()
    else
      @openOptions()

  documnentClicked: (e) =>
    klass = e.target.className
    unless klass.match( /(styled_select_selected|styled_select_option)/ )
      @selectClicked()

  optionClicked: (target) =>
    @selectedValue = target.innerHTML

    @setSelected(target.getAttribute( 'data-option-index' ))
    @selectClicked()
    @fireChangeEvent() # fire change event for actual select box
