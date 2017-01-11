import React from 'react';
import ReactDOM from 'react-dom';
import Moment from 'moment';

export default class UserSkillHistoryTimeline extends React.Component {
  minimumSVGwidthScale = 5
  minimumSVGwidth = 500
  nextDaysOnLongDateRange = 20
  nextDaysOnShortDateRange = 10
  previousDays = 5
  labelFontSize = 14
  chartHeight = 70
  chartPadding = 10
  chartStrokeWidth = 5
  gridLabelsHeight = 35
  legendWidth = 100

  totalDays = null
  previousDaysWidth = null
  nextDaysWidth = null
  heightWidth = null
  svgWidth = null
  svgWidthScale = null
  containerWidth = null
  nextDays = null

  verticalLineAttributes = {
    strokeWidth: '1',
    strokeDasharray: '1, 6',
    stroke: 'black'
  };

  noteAttributes = {
    strokeWidth: '1',
    stroke: '#084F73',
    fill: '#23a9db'
  };

  constructor(props) {
    super(props);
    this.updateComponentProperties(props);
  }

  componentDidMount() {
    this.scrollRight();
    this.initNotePopovers();
    this.initLegendPopover();
  }

  componentWillUpdate(props) {
    this.updateComponentProperties(props);
  }

  componentDidUpdate() {
    this.scrollRight();
    this.initNotePopovers();
  }

  render() {
    const loadingStateClass = this.props.loadingState ? `${this.props.cssNamespace}--loading` : '';

    return <div className={`${this.props.cssNamespace} ${loadingStateClass}`}>
      {this.getSkillLabels()}
      {this.getTimeline()}
    </div>;
  }

  getLegend() {
    const rateItems = [];

    for (let i = 0; i <= 3; ++i) {
      const text = `Skill rate ${i}`;

      rateItems.push(
        <li className={`${this.props.cssNamespace}__legend-list-item`}>
          <div className={`${this.props.cssNamespace}__legend-list-item-symbol
            ${this.props.cssNamespace}__legend-list-item-symbol--rate-${i}`}></div>
          {text}
        </li>
      );
    }

    return (
      <div className={`${this.props.cssNamespace}__legend`}>
        <div className={`${this.props.cssNamespace}__legend-title`}>Legend:</div>
        <ul className={`${this.props.cssNamespace}__legend-list`}>
          {rateItems}
          <li className={`${this.props.cssNamespace}__legend-list-item ${this.props.cssNamespace}__legend-list-item--top-margin`}>
            <div className={`${this.props.cssNamespace}__legend-list-item-symbol
              ${this.props.cssNamespace}__legend-list-item-symbol--dashed`}></div>
            Normal skill
          </li>
          <li className={`${this.props.cssNamespace}__legend-list-item`}>
            <div className={`${this.props.cssNamespace}__legend-list-item-symbol`}></div>
            Favorite skill
          </li>
        </ul>
      </div>
    );
  }

  initNotePopovers() {
    $(`.${this.props.cssNamespace}__note-popover-entry-point`).popover();
  }

  initLegendPopover() {
    const legendPopoverHTML = document.createElement('div');

    ReactDOM.render(this.getLegend(), legendPopoverHTML);
    $(`.${this.props.cssNamespace}__legend-popover-entry-point`).popover({html: true, content: legendPopoverHTML.innerHTML});
  }

  updateComponentProperties({model, containerWidth}) {
    const requiredDays = this.previousDays + model.meta.maximumDays + this.nextDaysOnShortDateRange;
    const svgWidth = containerWidth - this.legendWidth;

    if (requiredDays * this.minimumSVGwidthScale < svgWidth) {
      this.svgWidthScale = svgWidth / requiredDays;
      this.nextDays = this.nextDaysOnShortDateRange;
    } else {
      this.svgWidthScale = this.minimumSVGwidthScale;
      this.nextDays = this.nextDaysOnLongDateRange;
    }

    this.svgWidth = requiredDays * this.svgWidthScale;
    this.nextDaysWidth = this.nextDays * this.svgWidthScale;
    this.previousDaysWidth = this.previousDays * this.svgWidthScale;
    this.svgHeight = model.data.length * (this.chartHeight + this.chartPadding * 2) + this.gridLabelsHeight;
    this.totalDays = this.svgWidth / this. svgWidthScale;
  }

  scrollRight() {
    const {svgWidth, props: {cssNamespace}} = this;
    $(ReactDOM.findDOMNode(this)).find(`.${cssNamespace}__timeline`).scrollLeft(svgWidth);
  }

  getSkillLabels() {
    const {props: {cssNamespace, model: {data}}} = this;
    const skillLabels = data.reduce((acc, skillData) => acc.concat(
      <li className={`${cssNamespace}__labels-item`}>{skillData.skillName}</li>
    ), []);

    return (
      <div className={`${cssNamespace}__left-column`}>
        <button className={`btn btn-info ${cssNamespace}__legend-popover-entry-point`}>Legend</button>
        <ul className={`${cssNamespace}__labels`}>{skillLabels}</ul>
      </div>
    );
  }

  getTimeline() {
    const {svgWidth, svgHeight, props: {cssNamespace}} = this;

    return <div className={`${cssNamespace}__timeline`}>
      <svg version="1.1" baseProfile="full" width={svgWidth} height={svgHeight} xmlns="http://www.w3.org/2000/svg">
        {this.getTimelineBackground()}
        {this.getGridLinesWithLabels()}
        {this.getCharts()}
      </svg>
    </div>;
  }

  getTimelineBackground() {
    const {svgWidth, chartHeight, chartPadding, gridLabelsHeight, props: {model: {data: {length}}}} = this;
    const elements = [];

    for (let i = 0; i < length; ++i) {
      const height = chartHeight + 2 * chartPadding;
      const rectanglePositionY = (chartHeight + chartPadding * 2) * i + gridLabelsHeight;
      const linePositionY = rectanglePositionY + height;

      elements.push(
        this.getJSXobject({tagName: 'rect', attributes: {
          x: '0',
          y: rectanglePositionY,
          width: svgWidth,
          fill: i % 2 === 0 ? '#f2f4f5' : 'white',
          height
        }}),
        this.getJSXobject({tagName: 'line', attributes: {
          x1: '0',
          y1: linePositionY,
          x2: svgWidth,
          y2: linePositionY,
          strokeWidth: '1',
          stroke: '#d6dade'
        }})
      );
    }

    return elements;
  }

  getCharts() {
    const {chartHeight, chartPadding, gridLabelsHeight, svgWidth, nextDaysWidth, svgWidthScale, props: {model: {data}}} = this;

    return data.reduce((acc, {points, maxRate, totalDays}, index) => {
      const offsetTop = (chartHeight + chartPadding * 2) * index + chartPadding + gridLabelsHeight;
      const offsetLeft = svgWidth - nextDaysWidth - (totalDays * svgWidthScale);

      return acc.concat(this.getChart(points, maxRate, offsetTop, offsetLeft));
    }, []);
  }

  getChart(points, maxRate, offsetTop, offsetLeft) {
    const {svgWidthScale, chartStrokeWidth, noteAttributes, verticalLineAttributes, chartHeight, props: {cssNamespace}} = this;
    const verticalLines = [];
    const horizontalLines = [];
    const notes = [];

    let previousNote = '';
    let previousPointX = offsetLeft;
    let previousPointY = offsetTop + chartHeight;

    points.forEach(({rate, days, favorite, note}, index) => {
      const {stroke, strokeDasharray, strokeWidth, nextPointX, nextPointY} = this.getChartAttributes({
        rate, days, favorite, maxRate, chartHeight, svgWidthScale, chartStrokeWidth, previousPointX, offsetTop
      });

      horizontalLines.push(this.getJSXobject({tagName: 'line', attributes: {
        x1: previousPointX,
        y1: nextPointY,
        x2: nextPointX,
        y2: nextPointY,
        strokeWidth,
        strokeDasharray,
        stroke
      }}));

      if (previousPointY !== nextPointY && index > 0) {
        verticalLines.push(this.getJSXobject({tagName: 'line', attributes: {
          x1: previousPointX,
          y1: previousPointY,
          x2: previousPointX,
          y2: nextPointY
        }}));
      }

      if (note !== '' && note !== previousNote) {
        notes.push(this.getJSXobject({tagName: 'circle', attributes: {
          'data-placement': 'top',
          'data-container': 'body',
          'data-trigger': 'hover',
          'data-content': note,
          className: `${cssNamespace}__note-popover-entry-point`,
          cx: previousPointX,
          cy: nextPointY,
          r: '6'
        }}));
      }

      previousNote = note;
      previousPointX = nextPointX;
      previousPointY = nextPointY;
    });

    return [
      this.getJSXobject({tagName: 'g', attributes: verticalLineAttributes, content: verticalLines}),
      this.getJSXobject({tagName: 'g', content: horizontalLines}),
      this.getJSXobject({tagName: 'g', attributes: noteAttributes, content: notes})
    ];
  }

  getChartAttributes({rate, maxRate, chartHeight, days, svgWidthScale, favorite, chartStrokeWidth, previousPointX, offsetTop}) {
    const height = rate === 0 ? 0 : rate / maxRate * chartHeight;
    const width = days * svgWidthScale;

    return {
      stroke: this.getChartColor(rate, maxRate),
      strokeDasharray: favorite ? 'none' : '10, 10',
      strokeWidth: favorite ? chartStrokeWidth : chartStrokeWidth / 2,
      nextPointX: previousPointX + width,
      nextPointY: offsetTop + chartHeight - height
    };
  }

  getJSXobject({tagName: TagName, attributes, content}) {
    return <TagName {...attributes}>{content}</TagName>;
  }

  getChartColor(rate, maxRate) {
    const value = rate / maxRate;

    if (value === 0) return '#FF2D0E';
    else if (value >= 0.25 && value < 0.5) return '#E87200';
    else if (value >= 0.5 && value < 0.75) return '#FFC300';
    else if (value >= 0.75 && value <= 1) return '#57B80F';
    else return 'black';
  }

  getGridLinesWithLabels() {
    //const {startDate, endDate} = this.props;
    const nowDate = Moment();
    const startDate = Moment(nowDate).subtract(this.totalDays - this.nextDays, 'days');
    const endDate = Moment(nowDate).add(this.nextDays, 'days');
    const currentDate = Moment(startDate);
    const elements = [];

    // vertical lines with labels
    while (currentDate.diff(endDate, 'days') < -30) {
      currentDate.startOf('month').add(1, 'months');
      const positionX = currentDate.diff(startDate, 'days') * this.svgWidthScale;

      elements.push(...this.getVerticalLineWithLabel(positionX, currentDate.format('MMMM Y'), 10, 10, "black", "#d6dade"));
    }

    // current day line with label
    const positionX = Moment().diff(startDate, 'days') * this.svgWidthScale;
    elements.push(...this.getVerticalLineWithLabel(positionX, 'Today', 40, 10, "red", "red"));

    // horizontal line
    elements.push(<line x1="0" y1={this.gridLabelsHeight} x2={this.svgWidth} y2={this.gridLabelsHeight} strokeWidth="1" stroke="#d6dade" />);

    return elements;
  }

  getVerticalLineWithLabel(positionX, labelText, labelOffsetTop, labelOffsetLeft, labelColor, lineColor) {
    return [
      <line x1={positionX} y1="0" x2={positionX} y2={this.svgHeight} strokeWidth="1" stroke={lineColor} />,
      <text x={positionX + labelOffsetLeft} y={this.labelFontSize + labelOffsetTop}
        fontFamily="Helvetica Neue" fontSize={this.labelFontSize} fill={labelColor}>{labelText}</text>
    ];
  }
}
