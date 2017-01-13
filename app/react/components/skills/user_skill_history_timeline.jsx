import {Component} from 'react';
import ReactDOM from 'react-dom';
import Moment from 'moment';
import {LONG_MONTH_DAY} from '../../constants/date_formats';
import {
  YELLOW, RED, SUNSET, GREEN, BLACK, GREY,
  WHITE, DARK_BLUE, LIGHT_BLUE, LIGHT_GREY
} from '../../constants/colors';
import classNames from 'classnames';

export default class UserSkillHistoryTimeline extends Component {
  minimumSVGwidthScale = 5
  labelFontSize = 14
  chartHeight = 70
  chartPadding = 10
  chartStrokeWidth = 5
  gridLabelsHeight = 35
  legendWidth = 200

  svgWidth = null
  svgWidthScale = null
  svgHeight = null

  verticalLineAttributes = {
    strokeWidth: '1',
    strokeDasharray: '1, 6',
    stroke: BLACK
  };

  noteAttributes = {
    strokeWidth: '1',
    stroke: DARK_BLUE,
    fill: LIGHT_BLUE
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
    const {loadingState, cssNamespace} = this.props;
    const loadingStateClass = loadingState ? `${cssNamespace}--loading` : '';

    return (
      <div className={`${cssNamespace} ${loadingStateClass}`}>
        {this.getSkillLabels()}
        {this.getTimeline()}
      </div>
    );
  }

  getLegend() {
    const {cssNamespace} = this.props;
    const rateItems = [];

    for (let i = 0; i <= 3; ++i) {
      const text = `Skill rate ${i}`;

      rateItems.push(
        <li className={`${cssNamespace}__legend-list-item`}>
          <div
            className={classNames(
              `${cssNamespace}__legend-list-item-symbol`,
              `${cssNamespace}__legend-list-item-symbol--rate-${i}`
            )}>
          </div>
          {text}
        </li>
      );
    }

    return (
      <div className={`${cssNamespace}__legend`}>
        <div className={`${cssNamespace}__legend-title`}>Legend:</div>
        <ul className={`${cssNamespace}__legend-list`}>
          {rateItems}
          <li
            className={classNames(
              `${cssNamespace}__legend-list-item`,
              `${cssNamespace}__legend-list-item--top-margin`
            )}
          >
            <div
              className={classNames(
                `${cssNamespace}__legend-list-item-symbol`,
                `${cssNamespace}__legend-list-item-symbol--dashed`
              )}
            >
            </div>
            Normal skill
          </li>
          <li className={`${cssNamespace}__legend-list-item`}>
            <div className={`${cssNamespace}__legend-list-item-symbol`}></div>
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

  updateComponentProperties({model, containerWidth, startDate, endDate}) {
    const {gridLabelsHeight, legendWidth, minimumSVGwidthScale, chartHeight, chartPadding} = this;

    const daysInRange = Moment(endDate).diff(startDate, 'days');
    const extraDaysForMargin = this.getExtraDaysForMargin(daysInRange);
    const requiredDays = daysInRange + extraDaysForMargin;

    const timelineWidth = containerWidth - legendWidth;
    const svgWidthScale = this.getSVGwidthScale(timelineWidth, requiredDays, minimumSVGwidthScale);

    this.svgWidth = requiredDays * svgWidthScale;
    this.svgHeight = model.length * (chartHeight + chartPadding * 2) + gridLabelsHeight;
    this.svgWidthScale = svgWidthScale;
  }

  getSVGwidthScale(width, days, minimumScale) {
    const scale = width / days;
    return scale < minimumScale ? minimumScale : scale;
  }

  getExtraDaysForMargin(days) {
    if (days < 30) return 5;
    if (days < 90) return 10;
    return 30;
  }

  scrollRight() {
    const {svgWidth, props: {cssNamespace}} = this;
    $(ReactDOM.findDOMNode(this)).find(`.${cssNamespace}__timeline`).scrollLeft(svgWidth);
  }

  getSkillLabels() {
    const {legendWidth, props: {cssNamespace, model}} = this;
    const skillLabels = model.reduce((acc, skillData) => acc.concat(
      <li className={`${cssNamespace}__labels-item`}>{skillData.skillName}</li>
    ), []);

    return (
      <div className={`${cssNamespace}__left-column`}>
        <button className={`btn btn-info ${cssNamespace}__legend-popover-entry-point`}>Legend</button>
        <ul className={`${cssNamespace}__labels`} style={{width: legendWidth + 'px'}}>{skillLabels}</ul>
      </div>
    );
  }

  getTimeline() {
    const {svgWidth, svgHeight, props: {cssNamespace}} = this;

    return <div className={`${cssNamespace}__timeline`}>
      <svg
        version="1.1"
        baseProfile="full"
        width={svgWidth}
        height={svgHeight}
        xmlns="http://www.w3.org/2000/svg"
      >
        {this.getTimelineBackground()}
        {this.getGridLinesWithLabels()}
        {this.getCharts()}
      </svg>
    </div>;
  }

  getTimelineBackground() {
    const {svgWidth, chartHeight, chartPadding, gridLabelsHeight, props: {model: {length}}} = this;
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
          fill: i % 2 === 0 ? LIGHT_GREY : WHITE,
          height
        }}),
        this.getJSXobject({tagName: 'line', attributes: {
          x1: '0',
          y1: linePositionY,
          x2: svgWidth,
          y2: linePositionY,
          strokeWidth: '1',
          stroke: GREY
        }})
      );
    }

    return elements;
  }

  getCharts() {
    const {chartHeight, chartPadding, gridLabelsHeight, svgWidthScale, props: {model}} = this;

    return model.reduce((acc, {points, maxRate, totalDays, daysOffset}, index) => {
      const offsetTop = (chartHeight + chartPadding * 2) * index + chartPadding + gridLabelsHeight;
      const offsetLeft = daysOffset * svgWidthScale;

      return acc.concat(this.getChart(points, maxRate, offsetTop, offsetLeft));
    }, []);
  }

  getChart(points, maxRate, offsetTop, offsetLeft) {
    const {
      svgWidthScale, chartStrokeWidth, noteAttributes,
      verticalLineAttributes, chartHeight, props: {cssNamespace}
    } = this;
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

    if (value < 0.25) return RED;
    if (value < 0.5) return SUNSET;
    if (value < 0.75) return YELLOW;
    if (value <= 1) return GREEN;
    return BLACK;
  }

  getGridLinesWithLabels() {
    const {
      svgWidthScale, labelFontSize, gridLabelsHeight,
      svgWidth, svgHeight, props: {startDate, endDate}
    } = this;
    const currentDate = Moment(startDate);
    const lines = [];
    const labels = [];

    while (currentDate.diff(endDate, 'days') < -30) {
      currentDate.startOf('month').add(1, 'months');
      const positionX = currentDate.diff(startDate, 'days') * svgWidthScale;

      lines.push(this.getJSXobject({tagName: 'line', attributes: {
        x1: positionX,
        y1: '0',
        x2: positionX,
        y2: svgHeight,
        stroke: GREY
      }}));

      labels.push(this.getJSXobject({tagName: 'text', content: currentDate.format(LONG_MONTH_DAY), attributes: {
        x: positionX + 10,
        y: labelFontSize + 10,
        fill: BLACK
      }}));
    }

    const positionX = Moment().diff(startDate, 'days') * svgWidthScale;

    lines.push(
      this.getJSXobject({tagName: 'line', attributes: {
        x1: positionX,
        y1: '0',
        x2: positionX,
        y2: svgHeight,
        stroke: RED
      }}),
      this.getJSXobject({tagName: 'line', attributes: {
        x1: '0',
        y1: gridLabelsHeight,
        x2: svgWidth,
        y2: gridLabelsHeight,
        stroke: GREY
      }})
    );

    labels.push(this.getJSXobject({tagName: 'text', content: 'Today', attributes: {
      x: positionX + 10,
      y: labelFontSize + 40,
      fill: RED
    }}));

    return [
      this.getJSXobject({tagName: 'g', content: lines, attributes: {strokeWidth: '1'}}),
      this.getJSXobject({tagName: 'g', content: labels, attributes: {
        fontFamily: 'Helvetica Neue',
        fontSize: labelFontSize}
      })
    ];
  }
}
