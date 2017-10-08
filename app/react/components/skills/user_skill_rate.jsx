import React, {PropTypes} from 'react';
import UserSkillRateSource from '../../sources/UserSkillRateSource';
import RateScale from '../rate-scale';
import _ from 'lodash';

export default class UserSkillRate extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      favorite: props.favorite,
      note: props.note,
      rate: props.rate,
      id: props.id,
    };
    this.onFavoriteChange = this.onFavoriteChange.bind(this);
    this.onNoteChange = this.onNoteChange.bind(this);
    this.onRateChange = this.onRateChange.bind(this);
    this.userSkillRateSaved = this.userSkillRateSaved.bind(this);
    this.failedToSaveUserSkillRate = this.failedToSaveUserSkillRate.bind(this);
    this.submitInterval = null;
  }

  onFavoriteChange() {
    this.setState({ favorite: !this.state.favorite });
    this.submit();
  }

  onNoteChange(event) {
    this.setState({ note: event.currentTarget.value });
    this.submit();
  }

  onRateChange(newRate) {
    this.setState({ rate: newRate });
    this.submit();
  }

  userSkillRateSaved() {
    const message = I18n.t("skills.message.success", {skill: this.props.name});
    Messenger({theme: 'flat'}).success({
      message: message, hideAfter: 3, showCloseButton: true
    });
  }

  failedToSaveUserSkillRate() {
    const message = I18n.t("skills.message.error", {skill: this.props.name});
    Messenger({theme: 'flat'}).error({
      message: message, hideAfter: 3, showCloseButton: true
    });
  }

  submit() {
    clearTimeout(this.submitInterval);
    this.submitInterval = setTimeout(() =>
      {
        UserSkillRateSource.update(
          this.state
        ).done(
          this.userSkillRateSaved
        ).fail(
          this.failedToSaveUserSkillRate
        );
      },
      2000
    );
  }

  rateComponent() {
    return <RateScale key={this.props.id} rate={this.state.rate} rateType={this.props.rate_type} onRateChange={this.onRateChange}/>;
  }

  componentDidMount() {
    $('[data-toggle="tooltip"]').tooltip();
  }

  render() {
    const favoriteClass = `skill__favorite glyphicon ${this.state.favorite ? 'glyphicon-heart selected' : 'glyphicon-heart-empty'}`;

    const rateStars = this.rateComponent();

    return(
      <tr className="skill__row">
        <td>{this.props.name}</td>
        <td>{this.props.description}</td>
        <td>
          {rateStars}
        </td>
        <td className="skill__row__favorite-btn" onClick={this.onFavoriteChange}>
          <i
            className={favoriteClass}
            data-toggle="tooltip"
            data-placement="top"
            title={I18n.t("skills.favorite")}
          ></i>
        </td>
        <td>
          <textarea
            className="skill__note form-control"
            rows="1"
            cols="30"
            placeholder={I18n.t("skills.add_note")}
            value={this.state.note}
            onChange={this.onNoteChange}
          >
          </textarea>
        </td>
      </tr>
    );
  }
}
