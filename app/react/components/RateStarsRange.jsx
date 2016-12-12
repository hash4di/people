import React, {PropTypes} from 'react';
import _ from 'lodash';

export default class RateStarsRange extends React.Component {
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
    $('[data-toggle="tooltip"]').tooltip()
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

  rateMinusClass(elementNumber) {
    if(elementNumber <= this.state.hoverNumber) {
      return "hovered";
    }else if(elementNumber == this.state.rate){
      return "selected";
    }
  }

  onMouseEnter(event) {
    this.state.hoverNumber = parseInt(event.currentTarget.dataset.id);
    this.setState(this.state);
  }

  onMouseLeave() {
    this.state.hoverNumber = -1;
    this.setState(this.state);
  }

  onRateChange(event) {
    const newRate = parseInt(event.currentTarget.dataset.id);
    this.state.rate = newRate;
    this.props.onRateChange(newRate);
    this.setState(this.state);
  }

  render() {
    return(
      <ul className="list-inline skill__rating">
        <li>
          <i
            className={`glyphicon glyphicon-minus skill__rate ${this.rateMinusClass(0)}`}
            onMouseEnter={this.onMouseEnter}
            onMouseLeave={this.onMouseLeave}
            onClick={this.onRateChange}
            data-id="0"
            data-toggle="tooltip"
            data-placement="top"
            title="Never was done anything. Lack of experience. Lack of confidence of dealing with this in project."
          ></i>
        </li>
        <li>
          <i
            className={`glyphicon skill__rate ${this.rateStarClass(1)}`}
            onMouseEnter={this.onMouseEnter}
            onMouseLeave={this.onMouseLeave}
            onClick={this.onRateChange}
            data-id="1"
            data-toggle="tooltip"
            data-placement="top"
            title="Once something has been done. There was some sort of contact. Lack of confidence of dealing with this in project. It requires re-read the documentation."
          ></i>
        </li>
        <li>
          <i
            className={`glyphicon skill__rate ${this.rateStarClass(2)}`}
            onMouseEnter={this.onMouseEnter}
            onMouseLeave={this.onMouseLeave}
            onClick={this.onRateChange}
            data-id="2"
            data-toggle="tooltip"
            data-placement="top"
            title="Was used several times. Sufficient knowledge to cope with this in project using documentation from time to time. I understand the concept."
          ></i>
        </li>
        <li>
          <i
            className={`glyphicon skill__rate ${this.rateStarClass(3)}`}
            onMouseEnter={this.onMouseEnter}
            onMouseLeave={this.onMouseLeave}
            onClick={this.onRateChange}
            data-id="3"
            data-toggle="tooltip"
            data-placement="top"
            title="Was used many times. Feeling of confidence in dealing with this in project. Documentation is addition."
          ></i>
        </li>
      </ul>
    );
  }
}
