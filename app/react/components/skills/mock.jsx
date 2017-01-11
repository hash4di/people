export default {
    getModel(data) {
    // Transform data to presented output
    return {
      meta: {
        maximumDays: 200
      },
      data: [
        {
          skillName: 'ember',
          totalDays: 100,
          maxRate: 3,
          points: [
            {
              days: 40,
              rate: 0,
              favorite: false,
              note: ''
            },
            {
              days: 20,
              rate: 1,
              favorite: false,
              note: 'notka 1'
            },
            {
              days: 10,
              rate: 2,
              favorite: false,
              note: 'notka 2'
            },
            {
              days: 30,
              rate: 3,
              favorite: false,
              note: ''
            }
          ]
        },
        {
          skillName: 'react',
          totalDays: 30,
          maxRate: 3,
          points: [
            {
              days: 5,
              rate: 0,
              favorite: false,
              note: ''
            },
            {
              days: 13,
              rate: 1,
              favorite: false,
              note: ''
            },
            {
              days: 10,
              rate: 2,
              favorite: false,
              note: ''
            },
            {
              days: 2,
              rate: 3,
              favorite: false,
              note: ''
            }
          ]
        },
        {
          skillName: 'git',
          totalDays: 200,
          maxRate: 3,
          points: [
            {
              days: 50,
              rate: 0,
              favorite: false,
              note: ''
            },
            {
              days: 20,
              rate: 1,
              favorite: false,
              note: 'blabla'
            },
            {
              days: 30,
              rate: 1,
              favorite: true,
              note: ''
            },
            {
              days: 20,
              rate: 1,
              favorite: false,
              note: 'blabla2'
            },
            {
              days: 50,
              rate: 2,
              favorite: true,
              note: ''
            },
            {
              days: 30,
              rate: 1,
              favorite: true,
              note: ''
            }
          ]
        },
        {
          skillName: 'jira',
          totalDays: 100,
          maxRate: 1,
          points: [
            {
              days: 20,
              rate: 0,
              favorite: false,
              note: ''
            },
            {
              days: 80,
              rate: 1,
              favorite: false,
              note: 'awesome'
            }
          ]
        }
      ]
    };
  },

getModel2(data) {
    // Transform data to presented output
    return {
      meta: {
        maximumDays: 100
      },
      data: [
        {
          skillName: 'php',
          totalDays: 30,
          maxRate: 3,
          points: [
            {
              days: 0,
              rate: 0,
              favorite: false,
              note: 'ooo'
            },
            {
              days: 10,
              rate: 1,
              favorite: true,
              note: ''
            },
            {
              days: 10,
              rate: 2,
              favorite: true,
              note: 'nie'
            },
            {
              days: 10,
              rate: 3,
              favorite: true,
              note: ''
            }
          ]
        },
        {
          skillName: 'rails',
          totalDays: 50,
          maxRate: 3,
          points: [
            {
              days: 5,
              rate: 0,
              favorite: false,
              note: ''
            },
            {
              days: 10,
              rate: 1,
              favorite: false,
              note: ''
            },
            {
              days: 10,
              rate: 2,
              favorite: false,
              note: ''
            },
            {
              days: 25,
              rate: 3,
              favorite: true,
              note: ''
            }
          ]
        },
        {
          skillName: 'docker',
          totalDays: 100,
          maxRate: 3,
          points: [
            {
              days: 0,
              rate: 0,
              favorite: false,
              note: 'utanhu'
            },
            {
              days: 20,
              rate: 1,
              favorite: false,
              note: 'utnahuso'
            },
            {
              days: 30,
              rate: 1,
              favorite: false,
              note: ''
            },
            {
              days: 20,
              rate: 1,
              favorite: true,
              note: ''
            },
            {
              days: 30,
              rate: 2,
              favorite: true,
              note: ''
            }
          ]
        },
        {
          skillName: 'toggl',
          totalDays: 100,
          maxRate: 1,
          points: [
            {
              days: 20,
              rate: 0,
              favorite: true,
              note: ''
            },
            {
              days: 80,
              rate: 1,
              favorite: false,
              note: ''
            }
          ]
        }
      ]
    };
  },

  getModel3(data) {
    // Transform data to presented output
    return {
      meta: {
        maximumDays: 30
      },
      data: [
        {
          skillName: 'php',
          totalDays: 30,
          maxRate: 3,
          points: [
            {
              days: 5,
              rate: 0,
              favorite: false,
              note: 'ooo'
            },
            {
              days: 5,
              rate: 1,
              favorite: true,
              note: ''
            },
            {
              days: 10,
              rate: 2,
              favorite: true,
              note: 'nie'
            },
            {
              days: 10,
              rate: 3,
              favorite: true,
              note: ''
            }
          ]
        }
      ]
    };
  },

  getModel4(data) {
    // Transform data to presented output
    return {
      meta: {
        maximumDays: 300
      },
      data: [
        {
          skillName: 'trello',
          totalDays: 300,
          maxRate: 3,
          points: [
            {
              days: 50,
              rate: 0,
              favorite: false,
              note: 'ooo'
            },
            {
              days: 50,
              rate: 1,
              favorite: true,
              note: ''
            },
            {
              days: 100,
              rate: 2,
              favorite: true,
              note: 'nie'
            },
            {
              days: 100,
              rate: 3,
              favorite: true,
              note: ''
            }
          ]
        }
      ]
    };
  },

  getModel5() {
    return {"data":[
      {"skillName":"Web Interface Design","maxRate":3,"points":[
        {"days":30,"favorite":false,"note":"cool","rate":1},
        //{"days":29,"favorite":true,"note":"test","rate":1},
        //{"days":30,"favorite":true,"note":"test","rate":2},
        //{"days":0,"favorite":false,"note":"","rate":3},
        //{"days":29,"favorite":true,"note":"test","rate":3},
        //{"days":18,"favorite":false,"note":"","rate":0},
        //{"days":11,"favorite":false,"note":"","rate":0}
      ],"totalDays":30}],"meta":{"maximumDays":30}};
  }
};
