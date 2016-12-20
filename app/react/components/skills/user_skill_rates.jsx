import React, {PropTypes} from 'react';
import UserSkillRate from './user_skill_rate';

export default class UsersSkillRates extends React.Component {

  render() {
    const rows = this.props.skills.map(skill => <UserSkillRate key={skill.id} skill={skill}/>);

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
