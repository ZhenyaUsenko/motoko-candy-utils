let json = {
  Class: [
    {
      name: 'id',
      value: {
        Text: 'TokenID5',
      },
      immutable: true,
    },
    {
      name: 'owner',
      value: {
        Principal: 'yfeng-n2phb-fvw3w-dnfcd-hhfm6-su6zv-mxljs-b74gr-iyf52-w2bro-lqe',
      },
      immutable: false,
    },
    {
      name: '__apps',
      value: {
        Array: {
          thawed: [
            {
              Class: [
                {
                  name: 'app_id',
                  value: {
                    Text: 'public.metadata',
                  },
                  immutable: true,
                },
                {
                  name: 'read',
                  value: {
                    Text: 'public',
                  },
                  immutable: true,
                },
                {
                  name: 'write',
                  value: {
                    Class: [
                      {
                        name: 'type',
                        value: {
                          Text: 'allow',
                        },
                        immutable: true,
                      },
                      {
                        name: 'list',
                        value: {
                          Array: {
                            thawed: [
                              {
                                Principal: 'rrkah-fqaaa-aaaaa-aaaaq-cai',
                              },
                            ],
                          },
                        },
                        immutable: true,
                      },
                    ],
                  },
                  immutable: true,
                },
                {
                  name: 'data',
                  value: {
                    Class: [
                      {
                        name: 'Serial Number',
                        value: {
                          Text: 'Se_test148',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Description',
                        value: {
                          Text: 'This Oyster Perpetual Explorer II in Oystersteel with an Oyster bracelet features a black dial with an arrow-shaped 24-hour hand and hour markers with a Chromalight display. Its highly legible dial, extremely resistant Oystersteel and waterproofness have made it the watch for the extremes.',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Brand',
                        value: {
                          Text: 'Rolex',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Family',
                        value: {
                          Text: 'Explorer III',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Model',
                        value: {
                          Text: 'Explorer',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Model Number',
                        value: {
                          Text: '81070-21-001-FB6A',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Year',
                        value: {
                          Text: '2021',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Gender',
                        value: {
                          Text: 'M',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Water Resistance',
                        value: {
                          Text: '300.00 m',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Diameter',
                        value: {
                          Text: '44.00 mm',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Jewels',
                        value: {
                          Text: '27',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Power Reserve',
                        value: {
                          Text: '46 h',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Type',
                        value: {
                          Text: 'Automatic',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Display',
                        value: {
                          Text: 'Analog',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Materials',
                        value: {
                          Text: 'Titanium',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Glass',
                        value: {
                          Text: 'Sapphire',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Back',
                        value: {
                          Text: 'Closed',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Shape',
                        value: {
                          Text: 'Round',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Height',
                        value: {
                          Text: '14.65 mm',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Color',
                        value: {
                          Text: 'Grey',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Finish',
                        value: {
                          Text: 'Gradient',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Index Type',
                        value: {
                          Text: 'Stick / Dot',
                        },
                        immutable: false,
                      },
                      {
                        name: 'Hand Style',
                        value: {
                          Text: 'Stick',
                        },
                        immutable: false,
                      },
                    ],
                  },
                  immutable: false,
                },
              ],
            },
          ],
        },
      },
      immutable: true,
    },
  ],
}

let jsonToIdl = (data, propName) => {
  if (data instanceof Object) {
    let isArray = data instanceof Array
    let keys = isArray ? [] : Object.keys(data)

    let recordType = isArray ? 'vec' : keys.length === 1 && /^([A-Z][a-z]+|frozen|thawed)$/.test(keys[0]) ? 'variant' : 'record'

    let items = isArray ? data.map((value) => jsonToIdl(value, '')) : keys.map((key) => `${key} = ${jsonToIdl(data[key], key)}`)

    return `${recordType} { ${items.join('; ')} }`
  } else if (propName === 'Principal') {
    return `principal ${JSON.stringify(data)}`
  } else {
    return JSON.stringify(data)
  }
}

console.log(jsonToIdl(json))
