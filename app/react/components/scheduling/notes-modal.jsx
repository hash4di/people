import React, {PropTypes} from 'react';
import Modal from 'react-modal';
import User from './user';

export default class NotesModal extends React.Component {
  static get PropTypes() {
    return {
      notes: React.PropTypes.string.isRequired
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      display: false
    };
  }

  render() {
    Modal.setAppElement('body');

    const modalStyles = {
      content : {
        top: '20%',
        left: '0',
        width: '50%',
        'background-color': 'white',
        border: '1px solid grey',
      }
    };

    const closeModal = () => this.setState({ display: false });
    const openModal = () => this.setState({ display: true });

    const modal = (
      <Modal
        className="modal-dialog modal-md"
        closeTimeoutMS={150}
        isOpen={true}
        onRequestClose={closeModal}
        style={modalStyles}
      >
        <div className="modal-header">
          <button className="close" type="button" onClick={closeModal}>
            <span aria-hidden="true">&times;</span>
            <span className="sr-only">Close</span>
          </button>
          <h4 className="modal-title">Notes</h4>
        </div>
        <div className="modal-body">
          {this.props.notes}
        </div>
      </Modal>
    );

    return(
      <button className="btn btn-primary user-notes" onClick={openModal}>
        Show notes
        { this.state.display ? modal : null }
      </button>
    );
  }
}
