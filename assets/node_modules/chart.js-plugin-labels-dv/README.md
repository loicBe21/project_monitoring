# Chart.js Plugin Labels for Chart.js v3+
[Chart.js](https://www.chartjs.org/) plugin to display labels on pie, doughnut and polar area chart. Forked from emn178/chartjs-plugin-labels.

## Demo
- [Demo](http://emn178.github.io/chartjs-plugin-labels/samples/demo/) from the original repo using Chart.js v2.x, but it's almost the same.

## Download
- [Compressed](https://raw.github.com/DavideViolante/chartjs-plugin-labels/master/dist/chartjs-plugin-labels.min.js)  
- [Uncompressed](https://raw.github.com/DavideViolante/chartjs-plugin-labels/master/src/chartjs-plugin-labels.js)

## CDN Link
You can put the below link in the script tag

    https://unpkg.com/chart.js-plugin-labels-dv/dist/chartjs-plugin-labels.min.js

## Installation
- `npm i chart.js-plugin-labels-dv`

## Usage
JavaScript
```JavaScript
new Chart(ctx, {
  type: type,
  data: data,
  options: {
    plugins: {
      labels: {
        // render 'label', 'value', 'percentage', 'image' or custom function, default is 'percentage'
        render: 'value',

        // precision for percentage, default is 0
        precision: 0,

        // identifies whether or not labels of value 0 are displayed, default is false
        showZero: true,

        // font size, default is defaultFontSize
        fontSize: 12,

        // font color, can be color array for each data or function for dynamic color, default is defaultFontColor
        fontColor: '#fff',

        // font style, default is defaultFontStyle
        fontStyle: 'normal',

        // font family, default is defaultFontFamily
        fontFamily: "'Helvetica Neue', 'Helvetica', 'Arial', sans-serif",

        // draw text shadows under labels, default is false
        textShadow: true,

        // text shadow intensity, default is 6
        shadowBlur: 10,

        // text shadow X offset, default is 3
        shadowOffsetX: -5,

        // text shadow Y offset, default is 3
        shadowOffsetY: 5,

        // text shadow color, default is 'rgba(0,0,0,0.3)'
        shadowColor: 'rgba(255,0,0,0.75)',

        // draw label in arc, default is false
        // bar chart ignores this
        arc: true,

        // position to draw label, available value is 'default', 'border' and 'outside'
        // bar chart ignores this
        // default is 'default'
        position: 'default',

        // draw label even it's overlap, default is true
        // bar chart ignores this
        overlap: true,

        // show the real calculated percentages from the values and don't apply the additional logic to fit the percentages to 100 in total, default is false
        showActualPercentages: true,

        // set images when `render` is 'image'
        images: [
          {
            src: 'image.png',
            width: 16,
            height: 16
          }
        ],

        // add padding when position is `outside`
        // default is 2
        outsidePadding: 4,

        // add margin of text when position is `outside` or `border`
        // default is 2
        textMargin: 4
      }
    }
  }
});

// custom render
{
  render: function (args) {
    // args will be something like:
    // { label: 'Label', value: 123, percentage: 50, index: 0, dataset: {...} }
    return '$' + args.value;

    // return object if it is image
    // return { src: 'image.png', width: 16, height: 16 };
  }
}

// dynamic fontColor
{
  fontColor: function (args) {
    // args will be something like:
    // { index: 0, dataset: {...} }
    return myColorTransfer(args.dataset.backgroundColor[index]);
  }
}
```

Support multiple options, eg.

```JavaScript
labels: [
  {
    render: 'label',
    position: 'outside'
  },
  {
    render: 'value'
  }
]
```

Global options

```JavaScript
Chart.defaults.global.plugins.labels = {
  // ...
};
```

### Angular
1. Install using `npm i chart.js-plugin-labels-dv`
2. Edit `angular.json` and add inside the `"scripts"` array: `"node_modules/chart.js/dist/chart.min.js"`
3. Inside the component where you want to use Chart.js: `import Chart from 'chart.js/auto';`

## License
[MIT license](http://www.opensource.org/licenses/MIT).

## Contact
The project's website is located at https://github.com/emn178/chartjs-plugin-labels  
Authors: Chen, Yi-Cyuan (emn178@gmail.com), Davide Violante
