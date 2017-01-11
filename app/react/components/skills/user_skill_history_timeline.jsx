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
            Favourite skill
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
    var $this = $(ReactDOM.findDOMNode(this));
    $this.find(`.${this.props.cssNamespace}__timeline`).scrollLeft(this.svgWidth);
  }

  getSkillLabels() {
    const skillLabels = this.props.model.data.reduce((acc, skillData) => {
      return acc.concat(<li className={`${this.props.cssNamespace}__labels-item`}>{skillData.skillName}</li>);
    }, []);

    return (<div className={`${this.props.cssNamespace}__left-column`}>
      <button className={`btn btn-info ${this.props.cssNamespace}__legend-popover-entry-point`}>Legend</button>
      <ul className={`${this.props.cssNamespace}__labels`}>{skillLabels}</ul>
    </div>);
  }

  getTimeline() {
    return <div className={`${this.props.cssNamespace}__timeline`}>
      <svg version="1.1" baseProfile="full" width={this.svgWidth} height={this.svgHeight} xmlns="http://www.w3.org/2000/svg">
        {this.getTimelineBackground()}
        {this.getCharts()}
        {this.getGridLinesWithLabels()}
      </svg>
    </div>;
  }

  getTimelineBackground() {
    const modelLenght = this.props.model.data.length;
    const elements = [];

    for (let i = 0; i < modelLenght; ++i) {
      const color = i % 2 === 0 ? '#f2f4f5' : 'white';
      const rectanglePositionY = (this.chartHeight + this.chartPadding * 2) * i + this.gridLabelsHeight;
      const height = this.chartHeight + 2 * this.chartPadding;
      const linePositionY = rectanglePositionY + height;

      elements.push(<rect x="0" y={rectanglePositionY} width={this.svgWidth} height={height} fill={color} />);
      elements.push(<line x1="0" y1={linePositionY} x2={this.svgWidth} y2={linePositionY} strokeWidth="1" stroke="#d6dade" />);
    }

    return elements;
  }

  getCharts() {
    return this.props.model.data.reduce((acc, skillData, index) => {
      const offsetTop = (this.chartHeight + this.chartPadding * 2) * index + this.chartPadding + this.gridLabelsHeight;
      const offsetLeft = this.svgWidth - this.nextDaysWidth - (skillData.totalDays * this.svgWidthScale);

      return acc.concat(this.getChart(skillData, this.chartHeight, offsetTop, offsetLeft));
    }, []);
  }

  getChart(data, chartHeight, offsetTop, offsetLeft) {
    const verticalLines = [];
    const horizontalLines = [];
    const points = [];
    let lastNote = '';

    let previousPointX = offsetLeft;
    let previousPointY = offsetTop + chartHeight;

    data.points.forEach((point, index) => {
      const height = point.rate === 0 ? 0 : point.rate / data.maxRate * chartHeight;
      const width = point.days * this.svgWidthScale;
      const chartColor = this.getChartColor(point.rate, data.maxRate);
      const strokeDasharray = point.favorite ? 'none' : '10, 10';
      const chartStrokeWidth = point.favorite ? this.chartStrokeWidth : this.chartStrokeWidth / 2;

      const nextPointX = previousPointX + width;
      const nextPointY = offsetTop + chartHeight - height;

      horizontalLines.push(this.getSVGline({
        x1: previousPointX,
        y1: nextPointY,
        x2: nextPointX,
        y2: nextPointY,
        strokeWidth: chartStrokeWidth,
        strokeDasharray: strokeDasharray,
        stroke: chartColor
      }));

      if (previousPointY !== nextPointY && index > 0) {
        verticalLines.push(this.getSVGline({
          x1: previousPointX,
          y1: previousPointY,
          x2: previousPointX,
          y2: nextPointY,
          strokeWidth: '1',
          strokeDasharray: '1, 6',
          stroke: 'black'
        }));
      }

      if (point.note !== '' && point.note !== lastNote) {
        points.push(<circle
          className={`${this.props.cssNamespace}__note-popover-entry-point`}
          data-placement="top" data-container="body" data-trigger="hover" data-content={point.note}
          cx={previousPointX} cy={nextPointY} r="6" strokeWidth="1" stroke="#084F73" fill="#23a9db"
        />);
      }

      lastNote = point.note;
      previousPointX = nextPointX;
      previousPointY = nextPointY;
    });

    return [].concat(verticalLines, horizontalLines, points);
  }

  getSVGline({x1, y1, x2, y2, strokeWidth, strokeDasharray, stroke}) {
    return <line x1={x1} y1={y1} x2={x2} y2={y2} strokeWidth={strokeWidth} strokeDasharray={strokeDasharray} stroke={stroke} />;
  }

  getChartColor(rate, maxRate) {
    const value = rate / maxRate;

    if (value === 0) {
      return '#FF2D0E';
    } else if (value >= 0.25 && value < 0.5) {
      return '#E87200';
    } else if (value >= 0.5 && value < 0.75) {
      return '#FFC300';
    } else if (value >= 0.75 && value <= 1) {
      return '#57B80F';
    } else {
      return 'black';
    }
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
