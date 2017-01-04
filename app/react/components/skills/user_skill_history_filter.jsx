import React from 'react';

export default class UserSkillHistoryFilter extends React.Component {
  render() {
    const {cssNamespace, listItems, listPrimaryText, onItemClick, setDateRange, fromDate, toDate, onDateChange} = this.props;
    const listElements = listItems.reduce((acc, listItem, index) => {
      return acc.concat(
        <li
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
        <button onClick={() => {setDateRange(1);}}>last month</button>
        <button onClick={() => {setDateRange(3);}}>last 3 months</button>
        From:
        <input type="date" value={fromDate} onChange={(event) => {onDateChange('fromDate', event.target.value);}} />
        To:
        <input type="date" value={toDate} onChange={(event) => {onDateChange('toDate', event.target.value);}} />
      </div>
    </div>;
  }
}
