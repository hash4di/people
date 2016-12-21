import React, {PropTypes} from 'react';
import UserSkillRate from './user_skill_rate';

export default class UsersSkillRates extends React.Component {

  render() {
    const rows = this.props.skills.map(skill =>
      <UserSkillRate
        key={skill.id}
        favorite={skill.favorite}
        note={skill.note}
        rate={skill.rate}
        rate_type={skill.rate_type}
        name={skill.name}
        description={skill.description}
        id={skill.id}
      />
    );

    return(
      <table className="table table-striped table-condensed">
        <thead>
          <tr>
            <th> Name </th>
            <th> Description </th>
            <th className="skill__rating_table_rate"> Rate </th>
            <th> Target </th>
            <th> Note </th>
          </tr>
        </thead>
        <tbody>
          {rows}
        </tbody>
      </table>
    );
  }
}
