import React, {PropTypes} from 'react';
import _ from 'lodash';

export default class RateStarsBoolean extends React.Component {
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

  rateMinusClass(elementNumber) {
    if(elementNumber <= this.state.hoverNumber) {
      return "hovered";
    }else if(elementNumber == this.state.rate){
      return "selected";
    }
  }

  onMouseEnter(event) {
    this.setState({ hoverNumber: parseInt(event.currentTarget.dataset.id) });
  }

  onMouseLeave() {
    this.setState({ hoverNumber: -1 });
  }

  onRateChange(event) {
    const newRate = parseInt(event.currentTarget.dataset.id);
    this.props.onRateChange(newRate);
    this.setState({ rate: newRate });
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
            title="I do not know the tool / methodology / language / pattern."
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
            title="I know the tool / methodology / language / pattern."
          ></i>
        </li>
      </ul>
    );
  }
}
