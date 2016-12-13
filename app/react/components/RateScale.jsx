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

  rateMinusClass(elementNumber) {
    if(elementNumber <= this.state.hoverNumber) {
      return "glyphicon-minus hovered";
    }else if(elementNumber == this.state.rate){
      return "glyphicon-minus selected";
    }else{
      return "glyphicon-minus";
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
    const iconElements = this.props.icons.map((el, index) => (
      <li>
        <i
          className={`glyphicon skill__rate ${index == 0 ? this.rateMinusClass(0) : this.rateStarClass(index)}`}
          onMouseEnter={this.onMouseEnter}
          onMouseLeave={this.onMouseLeave}
          onClick={this.onRateChange}
          data-id={index}
          data-toggle="tooltip"
          data-placement="top"
          title={el.title}
        ></i>
      </li>
    ));

    return(
      <ul className="list-inline skill__rating">
        {iconElements}
      </ul>
    );
  }
}
