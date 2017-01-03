import React from 'react';
import Moment from 'moment';

export default class UserSkillHistoryFilter extends React.Component {    
    constructor(props) {
        super(props);
        this.state = {};
        this.setDateRange(12, true);
    }
    
    setDateRange(months, firstSet) {
        const format = 'Y-MM-DD';
        const fromDate = Moment().subtract(months, 'months').format(format);
        const toDate = Moment().format(format);

        if (firstSet) {
            this.state.fromDate = fromDate;
            this.state.toDate = toDate;
        } else {
            this.setState({fromDate, toDate});
        }
    }

    onDateChange(dateInput, date) {
        this.setState({[dateInput]: date});
    }
    
    render() {
        const {cssNamespace, listItems, listPrimaryText, onItemClick} = this.props;
        const listElements = listItems.reduce((acc, listItem, index) => {
            return acc.concat(<li
                    className={listItem.isActive ? `${cssNamespace}__active-item` : ''}
                    onClick={() => {onItemClick(index);}}
                >{listItem.name}</li>
            );
        }, []);

        return <div className={cssNamespace}>
            <ul className={`${cssNamespace} nav nav-tabs`}>
                <li className="text-primary">{listPrimaryText}</li>
                {listElements}
            </ul>
            <div>
                <button onClick={() => {this.setDateRange(1);}}>last month</button>
                <button onClick={() => {this.setDateRange(3);}}>last 3 months</button>
                From:
                <input type="date" value={this.state.fromDate} onChange={(event) => {this.onDateChange('fromDate', event.target.value);}} />
                To:
                <input type="date" value={this.state.toDate} onChange={(event) => {this.onDateChange('toDate', event.target.value);}} />
            </div>
        </div>;
    }
}
