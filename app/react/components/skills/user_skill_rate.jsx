import React, {PropTypes} from 'react';
import UserSkillRateSource from '../../sources/UserSkillRateSource';
import RateScale from '../RateScale';
import _ from 'lodash';

export default class UserSkillRate extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      originalSkill: Object.assign({}, props.skill),
      skill: Object.assign({}, props.skill),
    };
    this.isDirty = this.isDirty.bind(this);
    this.onFavoriteChange = this.onFavoriteChange.bind(this);
    this.onNoteChange = this.onNoteChange.bind(this);
    this.onSubmit = this.onSubmit.bind(this);
    this.onRateChange = this.onRateChange.bind(this);
    this.userSkillRateSaved = this.userSkillRateSaved.bind(this);
    this.failedToSaveUserSkillRate = this.failedToSaveUserSkillRate.bind(this);
  }

  isDirty() {
    return !_.isEqual(this.state.originalSkill, this.state.skill);
  }

  onFavoriteChange() {
    this.state.skill.favorite = !this.state.skill.favorite;
    this.setState(this.state);
  }

  onNoteChange(event) {
    this.state.skill.note = event.currentTarget.value;
    this.setState(this.state);
  }

  userSkillRateSaved() {
    this.setState({ originalSkill: Object.assign({}, this.state.skill) });
    Messenger().success(`Your changes for: ${this.props.skill.name} are saved.`);
  }

  failedToSaveUserSkillRate() {
    Messenger().success(`Failed to save your changes for: ${this.props.skill.name}.`);
  }

  onSubmit() {
    UserSkillRateSource.update(
      this.state.skill
    ).done(
      this.userSkillRateSaved
    ).fail(
      this.failedToSaveUserSkillRate
    );
  }

  onRateChange(newRate) {
    this.state.skill.rate = newRate;
    this.setState(this.state);
  }

  ratingIcons() {
    return {
      range: [
        {
          title: "Never was done anything. Lack of experience. Lack of confidence of dealing with this in project.",
        },
        {
          title: "Once something has been done. There was some sort of contact. Lack of confidence of dealing with this in project. It requires re-read the documentation.",
        },
        {
          title: "Was used several times. Sufficient knowledge to cope with this in project using documentation from time to time. I understand the concept.",
        },
        {
          title: "Was used many times. Feeling of confidence in dealing with  this in project. Documentation is addition.",
        },
      ],
      boolean: [
        {
          title: "I do not know the tool / methodology / language / pattern.",
        },
        {
          title: "I know the tool / methodology / language / pattern.",
        },
      ]
    }[this.state.skill.rate_type];
  }

  rateComponent() {
    return <RateScale key={this.state.skill.id} rate={this.state.skill.rate} icons={this.ratingIcons()} onRateChange={this.onRateChange}/>;
  }

  componentDidMount() {
    $('[data-toggle="tooltip"]').tooltip()
  }

  render() {
    const saveDivClass = `btn ${this.isDirty() ? 'btn-info' : 'btn-primary disabled'}`
    const favoriteCLass = `skill__favorite glyphicon btn-lg ${this.state.skill.favorite ? 'glyphicon-pushpin text-primary' : 'glyphicon-minus'}`

    const rateStars = this.rateComponent();

    return(
      <tr className="skill__row">
        <td>{this.props.skill.name}</td>
        <td>{this.props.skill.description}</td>
        <td>
          {rateStars}
        </td>
        <td>
          <textarea className="skill__note form-control" rows="1" cols="30" onChange={this.onNoteChange} placeholder='Add note to your rate' value={this.state.skill.note}>
          </textarea>
        </td>
        <td onClick={this.onFavoriteChange}>
          <i
            className={favoriteCLass}
            data-toggle="tooltip"
            data-placement="top"
            title="skill I want to get better at."
          ></i>
        </td>
        <td>
          <div
            className={saveDivClass}
            onClick={this.onSubmit}
            data-toggle="tooltip"
            data-placement="top"
            title="Save your changes."
          >
            <i className="glyphicon glyphicon-floppy-disk"></i>
          </div>
        </td>
      </tr>
    );
  }
}
