import React, {PropTypes} from 'react';
import Select from 'react-select';
import ProjectUsersStore from '../../stores/ProjectUsersStore';
import MembershipActions from '../../actions/MembershipActions';

export default class AddUserToProject extends React.Component {
  constructor(props) {
    super(props);
    this.createMembership = this.createMembership.bind(this);
  }

  createMembership(userId) {
    const user = ProjectUsersStore.getUser(userId);
    const billableRole = user.primary_roles[0].billable;
    let params = {
      userId: userId,
      projectId: this.props.project.id,
      billable: billableRole,
      project_potential: this.props.project.potential
    };

    if(this.props.project.potential) {
      params.booked = true;
    }
    MembershipActions.create(params);
  }

  render() {
    const users = ProjectUsersStore.getUsersNotInProjectNow(this.props.project.id);
    const options = users.map(user => {
      return { label: `${user.last_name} ${user.first_name}`, value: user.id };
    });

    return(
      <div className="js-project-new-membership new-membership">
        <Select
          name="form-field-name"
          options={options}
          onChange={this.createMembership} />
      </div>
    );
  }
}

AddUserToProject.propTypes = {
  project: PropTypes.object.isRequired
};
