import React, {PropTypes} from 'react';
import Moment from 'moment';

export default class UserSkillTimeline extends React.Component {
  cssNamespace = 'user-skill-timeline'
  svgWidthScale = 5
  minimumSVGwidth = 1000
  nextDays = 40
  previousDays = 40
  labelFontSize = 14
  chartHeight = 100
  chartPadding = 10

  totalDays = null
  previousDaysWidth = null
  nextDaysWidth = null
  heightWidth = null
  svgWidth = null

  constructor(props) {
    super(props);
    this.model = this.getModel(props);

    this.nextDaysWidth = this.nextDays * this.svgWidthScale;
    this.previousDaysWidth = this.previousDays * this.svgWidthScale;

    // this should be taken from model
    const maximumDays = 30;
    const maximumDaysWidth = maximumDays * this.svgWidthScale;
    const requiredSVGwidth = this.previousDaysWidth + this.nextDaysWidth + maximumDaysWidth;

    this.svgHeight = this.model.length * (this.chartHeight + this.chartPadding * 2);
    this.svgWidth = requiredSVGwidth > this.minimumSVGwidth ? requiredSVGwidth : this.minimumSVGwidth;
    this.totalDays = this.svgWidth / this. svgWidthScale;
  }

  componentDidMount() {
    var $this = $(ReactDOM.findDOMNode(this));
    $this.find(`.${this.cssNamespace}__timelines`).scrollLeft(this.svgWidth);
  }

  render() {
    return <div className={this.cssNamespace}>
      {this.getSkillLabels()}
      {this.getTimeline()}
    </div>;
  }

  getModel(data) {
    return [
      {
        skillName: 'ember',
        totalDays: 23,
        maxRate: 4,
        updates: [
          {
            days: 5,
            rate: 0
          },
          {
            days: 10,
            rate: 1
          },
          {
            days: 5,
            rate: 2
          },
          {
            days: 3,
            rate: 4
          }
        ]
      },
      {
        skillName: 'react',
        totalDays: 30,
        maxRate: 4,
        updates: [
          {
            days: 5,
            rate: 0
          },
          {
            days: 10,
            rate: 1
          },
          {
            days: 10,
            rate: 2
          },
          {
            days: 2,
            rate: 3
          },
          {
            days: 3,
            rate: 4
          }
        ]
      },
      {
        skillName: 'git',
        totalDays: 20,
        maxRate: 4,
        updates: [
          {
            days: 5,
            rate: 0
          },
          {
            days: 7,
            rate: 1
          },
          {
            days: 5,
            rate: 2
          },
          {
            days: 3,
            rate: 1
          }
        ]
      },
      {
        skillName: 'jira',
        totalDays: 10,
        maxRate: 1,
        updates: [
          {
            days: 2,
            rate: 0
          },
          {
            days: 8,
            rate: 1
          }
        ]
      }
    ]
  }

  getSkillLabels() {
    const skillLabels = this.model.reduce((acc, skillData) => {
      return acc.concat(<li className={`${this.cssNamespace}__row-item ${this.cssNamespace}__skill-label`}>{skillData.skillName}</li>);
    }, []);

    return <ul className={`${this.cssNamespace}__labels`}>{skillLabels}</ul>;
  }

  getTimeline() {
    return <div className={`${this.cssNamespace}__timelines`}>
      <svg version="1.1" baseProfile="full" width={this.svgWidth} height={this.svgHeight} xmlns="http://www.w3.org/2000/svg">
        {this.getCharts()}
        {this.getGridLinesWithLabels()}
      </svg>
    </div>;
  }

  getCharts() {
    return this.model.reduce((acc, skillData, index) => {
      const offsetTop = (this.chartHeight + this.chartPadding * 2) * index + this.chartPadding;
      return acc.concat(this.getChart(skillData, this.chartHeight, offsetTop));
    }, []);
  }

  getChart(data, chartHeight, offsetTop) {
    const rectanglesWidth = data.totalDays * this.svgWidthScale;
    const offsetLeft = this.svgWidth - rectanglesWidth - this.nextDaysWidth;

    return data.updates.reduce((acc, rectangleData) => {
      const height = rectangleData.rate === 0 ? 0 : rectangleData.rate / data.maxRate * chartHeight;
      const width = rectangleData.days * this.svgWidthScale;
      const lastAccElement = acc[acc.length - 1];
      const lastAccElementPositionX = lastAccElement && lastAccElement.props ? lastAccElement.props.x : offsetLeft;
      const lastAccElementWidth = lastAccElement && lastAccElement.props ? lastAccElement.props.width : 0;
      const positionX = lastAccElementPositionX + lastAccElementWidth;
      const positionY = chartHeight - height + offsetTop;

      return acc.concat(<rect x={positionX} y={positionY} width={width} height={height} fill="red" />);
    }, []);
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

      elements.push(...this.getLineWithLabel(positionX, currentDate.format('MMMM Y'), 10, 10, "black", "black"));
    }

    // current day line with label
    const positionX = Moment().diff(startDate, 'days') * this.svgWidthScale;
    elements.push(...this.getLineWithLabel(positionX, 'Today', 40, 5, "red", "red"));

    // horizontal line
    elements.push(<line x1="0" y1={this.labelFontSize + 20} x2="100%" y2={this.labelFontSize + 20} strokeWidth="1" stroke="black" />);

    return elements;
  }

  getLineWithLabel(positionX, labelText, labelOffsetTop, labelOffsetLeft, labelColor, lineColor) {
    return [
      <line x1={positionX} y1="0%" x2={positionX} y2="100%" strokeWidth="1" stroke={lineColor} />,
      <text x={positionX + labelOffsetLeft} y={this.labelFontSize + labelOffsetTop}
        fontFamily="Helvetica Neue" fontSize={this.labelFontSize} fill={labelColor}>{labelText}</text>
    ];
  }
}
