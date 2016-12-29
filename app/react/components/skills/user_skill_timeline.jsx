import React, {PropTypes} from 'react';
import Moment from 'moment';

export default class UserSkillTimeline extends React.Component {
  cssNamespace = 'user-skill-timeline'
  svgHeight = 100
  svgWidthScale = 5
  minimumSVGwidth = 1000
  nextDays = 40
  previousDays = 40

  totalDays = null
  previousDaysWidth = null
  nextDaysWidth = null
  svgWidth = null

  constructor(props) {
    super(props);
    const preparedData = this.prepareData(props);

    this.state = {preparedData};
    this.nextDaysWidth = this.nextDays * this.svgWidthScale;
    this.previousDaysWidth = this.previousDays * this.svgWidthScale;

    // this should be taken from prepareData
    const maximumDays = 30;
    const maximumDaysWidth = maximumDays * this.svgWidthScale;
    const requiredSVGwidth = this.previousDaysWidth + this.nextDaysWidth + maximumDaysWidth;

    this.svgWidth = requiredSVGwidth > this.minimumSVGwidth ? requiredSVGwidth : this.minimumSVGwidth;
    this.totalDays = this.svgWidth / this. svgWidthScale;
  }

  componentDidMount() {
    var $this = $(ReactDOM.findDOMNode(this));
    $this.find(`.${this.cssNamespace}__timelines`).scrollLeft(this.svgWidth);
  }

  render() {
    return <div className={this.cssNamespace}>
      {this.getSkillLabels(this.state.preparedData)}
      {this.getSkillTimelines(this.state.preparedData)}
    </div>;
  }

  prepareData(data) {
    return [
      {
        skill: 'ember',
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
        skill: 'react',
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
        skill: 'git',
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
        skill: 'jira',
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

  createMonthSeparatorSVG() {
    const nextDays = this.nextDays;
    const nowDate = Moment();
    const startDate = Moment(nowDate).subtract(this.totalDays - this.nextDays, 'days');
    const endDate = Moment(nowDate).add(nextDays, 'days');
    const currentDate = Moment(startDate);
    const separators = [];
    
    while (currentDate.diff(endDate, 'days') < 0) {
      currentDate.startOf('month').add(1, 'months');
      
      const positionX = currentDate.diff(startDate, 'days') * this.svgWidthScale;
      separators.push(<line x1={positionX} y1="0%" x2={positionX} y2="100%" strokeWidth="2" stroke="black" />);
    }

    return <svg className={`${this.cssNamespace}__timeline-ui`} version="1.1" baseProfile="full" width={this.svgWidth} height={this.svgHeight} xmlns="http://www.w3.org/2000/svg">
      {separators}
    </svg>
  }

  createSkillTimelineSVG(data) {
    const rectanglesWidth = data.totalDays * this.svgWidthScale;
    const offsetLeft = this.svgWidth - rectanglesWidth - this.nextDaysWidth;

    const rectangles = data.updates.reduce((accumulator, update) => {
      const height = update.rate === 0 ? 0 : update.rate / data.maxRate * this.svgHeight;
      const width = update.days * this.svgWidthScale;
      const lastAccumulatorElement = accumulator[accumulator.length - 1];
      const lastAccumulatorElementPositionX = lastAccumulatorElement && lastAccumulatorElement.props ? lastAccumulatorElement.props.x : offsetLeft;
      const lastAccumulatorElementWidth = lastAccumulatorElement && lastAccumulatorElement.props ? lastAccumulatorElement.props.width : 0;
      const positionX = lastAccumulatorElementPositionX + lastAccumulatorElementWidth;
      const positionY = this.svgHeight - height;

      return accumulator.concat(<rect x={positionX} y={positionY} width={width} height={height} fill="red" />);
    }, []);

    return <svg className={`${this.cssNamespace}__row-item`} version="1.1" baseProfile="full" width={this.svgWidth} height={this.svgHeight} xmlns="http://www.w3.org/2000/svg">
      {rectangles}
    </svg>
  }

  getSkillTimelines(skillData) {
    const skillTimelines = skillData.reduce((accumulator, data) => {
      return accumulator.concat(this.createSkillTimelineSVG(data));
    }, []);
    const monthSeparatorSVG = this.createMonthSeparatorSVG();

    return <div className={`${this.cssNamespace}__timelines`}>{monthSeparatorSVG}{skillTimelines}</div>
  }

  getSkillLabels(skillData) {
    const skillLabels = skillData.reduce((accumulator, data) => {
      return accumulator.concat(<li className={`${this.cssNamespace}__row-item ${this.cssNamespace}__skill-label`}>{data.skill}</li>);
    }, []);
    
    return <ul className={`${this.cssNamespace}__labels`}>{skillLabels}</ul>;
  }
}
