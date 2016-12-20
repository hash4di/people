import React, {PropTypes} from 'react';
import _ from 'lodash';

export default class RateScale extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      rate: this.props.rate,
      hoverNumber: -1,
    };
    this.onMouseEnter = this.onMouseEnter.bind(this);
    this.onMouseLeave = this.onMouseLeave.bind(this);
    this.onRateChange = this.onRateChange.bind(this);
  }

  componentDidMount() {
    $('[data-toggle="tooltip"]').tooltip();
  }

  rateStarClass(elementNumber) {
    if(elementNumber <= this.state.hoverNumber) {
      return "glyphicon-star hovered";
    }else if(elementNumber <= this.state.rate){
      return "glyphicon-star selected";
    }else{
      return "glyphicon-star-empty";
    }
  }

  onMouseEnter(event) {
    this.setState({ hoverNumber: parseInt(event.currentTarget.dataset.id, 10) });
  }

  onMouseLeave() {
    this.setState({ hoverNumber: -1 });
  }

  onRateChange(e) {
    const newRate = parseInt(e.currentTarget.dataset.id, 10);
    this.props.onRateChange(newRate);
    this.setState({ rate: newRate });
  }

  scaleSize() {
    return this.props.rateType == 'boolean' ? [1] : [1,2,3];
  }

  scaleTranslation(number) {
    return I18n.t(`skills.rating.${this.props.rateType}`)[number];
  }

  render() {
    const iconElements = _.map(this.scaleSize(), (index) =>
      <li>
        <i
          className={`glyphicon skill__rate ${this.rateStarClass(index)}`}
          onMouseEnter={this.onMouseEnter}
          onMouseLeave={this.onMouseLeave}
          onClick={this.onRateChange}
          data-id={index}
          data-toggle="tooltip"
          data-placement="top"
          title={this.scaleTranslation(index)}
        ></i>
      </li>
    );

    const resetElement = this.state.rate > 0 ? (
      <li className="skill__clear_rate">
        <i
          className="glyphicon glyphicon-remove"
          onClick={this.onRateChange}
          title="Click to reset your rating"
          data-toggle="tooltip"
          data-placement="top"
          data-id="0"
        ></i>
      </li>
    ) : (
      ''
    );

    return(
      <ul className="list-inline skill__rating">
        {resetElement}
        {iconElements}
      </ul>
    );
  }
}
