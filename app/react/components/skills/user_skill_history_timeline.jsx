import React, {PropTypes} from 'react';
import Moment from 'moment';

export default class UserSkillHistoryTimeline extends React.Component {
  cssNamespace = 'user-skill-history-timeline'
  svgWidthScale = 5
  minimumSVGwidth = 1000
  nextDays = 20
  previousDays = 5
  labelFontSize = 14
  chartHeight = 70
  chartPadding = 10
  chartStrokeWidth = 5
  gridLabelsHeight = 35

  totalDays = null
  previousDaysWidth = null
  nextDaysWidth = null
  heightWidth = null
  svgWidth = null

  constructor(props) {
    super(props);
    this.updateComponentProperties(this.props.model);
  }

  componentDidMount() {
    this.scrollRight();
  }

  componentWillUpdate(props) {
    this.updateComponentProperties(this.props.model);
  }

  componentDidUpdate(props) {
    this.scrollRight();
  }

  render() {
    return <div className={this.cssNamespace}>
      {this.getSkillLabels()}
      {this.getTimeline()}
    </div>;
  }

  updateComponentProperties(model) {
    this.nextDaysWidth = this.nextDays * this.svgWidthScale;
    this.previousDaysWidth = this.previousDays * this.svgWidthScale;

    const maximumDaysWidth = model.meta.maximumDays * this.svgWidthScale;
    const requiredSVGwidth = this.previousDaysWidth + this.nextDaysWidth + maximumDaysWidth;

    this.svgHeight = model.skills.length * (this.chartHeight + this.chartPadding * 2) + this.gridLabelsHeight;
    this.svgWidth = requiredSVGwidth > this.minimumSVGwidth ? requiredSVGwidth : this.minimumSVGwidth;
    this.totalDays = this.svgWidth / this. svgWidthScale;
  }

  scrollRight() {
    var $this = $(ReactDOM.findDOMNode(this));
    $this.find(`.${this.cssNamespace}__timeline`).scrollLeft(this.svgWidth);
  }

  getSkillLabels() {
    const skillLabels = this.props.model.skills.reduce((acc, skillData) => {
      return acc.concat(<li className={`${this.cssNamespace}__labels-item`}>{skillData.skillName}</li>);
    }, []);

    return <ul className={`${this.cssNamespace}__labels`}>{skillLabels}</ul>;
  }

  getTimeline() {
    return <div className={`${this.cssNamespace}__timeline`}>
      <svg version="1.1" baseProfile="full" width={this.svgWidth} height={this.svgHeight} xmlns="http://www.w3.org/2000/svg">
        {this.getTimelineBackground()}
        {this.getCharts()}
        {this.getGridLinesWithLabels()}
      </svg>
    </div>;
  }

  getTimelineBackground() {
    const modelLenght = this.props.model.skills.length;
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
    return this.props.model.skills.reduce((acc, skillData, index) => {
      const offsetTop = (this.chartHeight + this.chartPadding * 2) * index + this.chartPadding + this.gridLabelsHeight;
      return acc.concat(this.getChart(skillData, this.chartHeight, offsetTop));
    }, []);
  }

  getChart(data, chartHeight, offsetTop) {
    const rectanglesWidth = data.totalDays * this.svgWidthScale;
    const offsetLeft = this.svgWidth - rectanglesWidth - this.nextDaysWidth;
    const verticalLines = [];
    const horizontalLines = [];

    data.updates.forEach((skillData) => {
      const height = skillData.rate === 0 ? 0 : skillData.rate / data.maxRate * chartHeight;
      const width = skillData.days * this.svgWidthScale;
      const positionY = chartHeight - height + offsetTop;
      const chartColor = this.getChartColor(skillData.rate, data.maxRate);
      const strokeDasharray = skillData.isFavourite ? 'none' : '10, 10';
      const chartStrokeWidth = skillData.isFavourite ? this.chartStrokeWidth : this.chartStrokeWidth / 2;

      const previousHorizontalLineProps = horizontalLines[horizontalLines.length - 1] &&
        horizontalLines[horizontalLines.length - 1].props ? horizontalLines[horizontalLines.length - 1].props : {};
      const previousHorizontalLinePositionX = previousHorizontalLineProps.x1 || offsetLeft;
      const previousHorizontalLinePositionY = previousHorizontalLineProps.y1 || 0;
      const previousHorizontalLineWidth = previousHorizontalLineProps.x2 - previousHorizontalLineProps.x1 || 0;
      
      const positionX = previousHorizontalLinePositionX + previousHorizontalLineWidth;
      horizontalLines.push(<line x1={positionX} y1={positionY} x2={positionX + width} y2={positionY}
        strokeWidth={chartStrokeWidth} strokeDasharray={strokeDasharray} stroke={chartColor} />);
      
      if (height !== 0) {
        verticalLines.push(<line x1={positionX} y1={previousHorizontalLinePositionY}
          x2={positionX} y2={positionY} strokeWidth="1" strokeDasharray="1, 6" stroke="black" />);
      }
    });

    return [].concat(verticalLines, horizontalLines);
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
