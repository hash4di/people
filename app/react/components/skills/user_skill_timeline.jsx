import React, {PropTypes} from 'react';
import Moment from 'moment';

export default class UserSkillTimeline extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      tom: Moment('2016-12-20T15:35:59.859+01:00').format("YYYY-MM-DD")
    };
    //debugger;

    const preparedData = [
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

    this.state.preparedData = preparedData;
  }

  componentDidMount() {
    var $this = $(ReactDOM.findDOMNode(this));
    $this.find(`.${this.cssNamespace}__timelines`).scrollLeft(this.svgWidth);
  }

  svgHeight = 100
  svgWidthScale = 5
  cssNamespace = 'user-skill-timeline'
  nextDays = 40
  // this has to be calculated
  svgWidth = 1500

  createSkillTimelineSVG(data) {
    const svgHeight = this.svgHeight;
    const svgWidth = this.svgWidth;
    const rectanglesWidth = data.totalDays * this.svgWidthScale;
    const nextDaysWidth = this.nextDays * this.svgWidthScale;
    const offsetLeft = this.svgWidth - rectanglesWidth - nextDaysWidth;

    const rectangles = data.updates.reduce((accumulator, update) => {
      const height = update.rate === 0 ? 0 : update.rate / data.maxRate * svgHeight;
      const width = update.days * this.svgWidthScale;
      const lastAccumulatorElement = accumulator[accumulator.length - 1];
      const lastAccumulatorElementPositionX = lastAccumulatorElement && lastAccumulatorElement.props ? lastAccumulatorElement.props.x : offsetLeft;
      const lastAccumulatorElementWidth = lastAccumulatorElement && lastAccumulatorElement.props ? lastAccumulatorElement.props.width : 0;
      const positionX = lastAccumulatorElementPositionX + lastAccumulatorElementWidth;
      const positionY = svgHeight - height;

      return accumulator.concat(<rect x={positionX} y={positionY} width={width} height={height} fill="red" />);
    }, []);

    return <svg className={`${this.cssNamespace}__row-item`} version="1.1" baseProfile="full" width={svgWidth} height={svgHeight} xmlns="http://www.w3.org/2000/svg">
      {rectangles}
    </svg>
  }

  getSkillTimelines(skillData) {
    const skillTimelines = skillData.reduce((accumulator, data) => {
      return accumulator.concat(this.createSkillTimelineSVG(data));
    }, []);

    return <div className={`${this.cssNamespace}__timelines`}>{skillTimelines}</div>
  }

  getSkillLabels(skillData) {
    const skillLabels = skillData.reduce((accumulator, data) => {
      return accumulator.concat(<li className={`${this.cssNamespace}__row-item ${this.cssNamespace}__skill-label`}>{data.skill}</li>);
    }, []);
    
    return <ul className={`${this.cssNamespace}__labels`}>{skillLabels}</ul>;
  }

  render() {
    return <div className={this.cssNamespace}>
      {this.getSkillLabels(this.state.preparedData)}
      {this.getSkillTimelines(this.state.preparedData)}
    </div>
  }
}
