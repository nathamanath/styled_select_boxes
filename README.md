# Javascript Styled Select Boxes

This js class creates an HTML facade for your select boxes allowing you to
style them as you like with your own css.

The aim is to allow custom select boxes, but without changing the default behaviour of
selects.

## Usage

```javascript

var selects = document.querySelectorAll('.styled'),
    select = document.getElementById('select');

StyledSelects.init(selects);

// You can still bind events to your real select boxes!
select.addEventListener('change', function(e){
  alert(this.options[this.selectedIndex].innerHTML)
}, false);

```

## Development

### Todo:

* docs
* refactor a lot
* test suite
* nice example

