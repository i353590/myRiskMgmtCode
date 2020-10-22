using RiskService from './risk-service';

annotate RiskService.Risks with {
    title  @title : 'Title' @UI.MultiLineText;
    prio   @title : 'Priority';
    descr  @title : 'Description' @UI.MultiLineText;
    miti   @title : 'Mitigation';
    bp     @title : 'Business Partner';
    impact @title : 'Impact';
}

annotate RiskService.BusinessPartners with {
    BusinessPartnerID @title : 'Business Partner';
    LastName        @title : 'Business Partner Name';
    FirstName       @title : 'First Name';
    Status          @title : 'Business Partner Status';
    risks           @title : 'Risk';
}

annotate RiskService.BusinessPartners @(Capabilities : {
    Insertable : false,
    Deletable  : false,
    Updatable  : true,
});

annotate RiskService.Risks @(Capabilities : {
    Deletable  : true,
    Insertable : true,
    Updatable  : true,
});

annotate RiskService.BusinessPartners with @(UI : {
    HeaderInfo : {
        TypeName       : 'BuisnessPartners Notification',
        TypeNamePlural : 'BuisnessPartners Notifications',
        Title          : {Value : BusinessPartnerID},
        Description    : {Value : LastName, }
    },
    LineItem   : [
    {Value : BusinessPartnerID},
    {Value : LastName},
    {Value : Status},
    ],
    Facets     : [{
        $Type  : 'UI.ReferenceFacet',
        Target : 'risks/@UI.LineItem#notifications',
        Label  : 'Risks Facet'
    }],
});

annotate RiskService.Mitigations with {
    ID          @(
        UI.Hidden,
        Common : {Text : description}
    );
    description @title : 'Description';
    owner       @title : 'Owner';
    timeline    @title : 'Timeline';
    risks       @title : 'Risks';
}

annotate RiskService.Risks with @(UI : {
    HeaderInfo       : {
        TypeName       : 'Risk',
        TypeNamePlural : 'Risks'
    },
    SelectionFields  : [prio],
    LineItem #notifications     : [
    {Value : title},
    {Value : miti_ID},
    {Value : descr},
    {
        Value       : prio,
        Criticality : criticality
    },
    {
        Value       : impact,
        Criticality : criticality
    }
    ],
    LineItem         : [
    {Value : title},
    {Value : miti_ID},
    {Value : bp_ID},
     {Value : descr},
    {
        Value       : prio,
        Criticality : criticality
    },
    {
        Value       : impact,
        Criticality : criticality
    }
    ],
    Facets           : [{
        $Type  : 'UI.ReferenceFacet',
        Label  : 'Main',
        Target : '@UI.FieldGroup#Main'
    }],
    FieldGroup #Main : {Data : [
    {Value : title},
    {Value : miti_ID},
    {Value : descr},
    {Value : bp_ID},
    {
        Value       : prio,
        Criticality : criticality
    },
    {
        Value       : impact,
        Criticality : criticality
    }
    ]}
}, ) {

};

annotate RiskService.Risks with {
    bp @(
        Common           : {
            //show text, not id for mitigation in the context of risks
            Text            : bp.LastName,
            TextArrangement : #TextOnly,
            ValueList       : {
                Label          : 'Business Partner',
                CollectionPath : 'BusinessPartners',
                Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : bp_ID,
                    ValueListProperty : 'BusinessPartnerID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'LastName'
                }
                ]
            }
        },
        UI.MultiLineText : IsActiveEntity
    );
}

annotate RiskService.Risks with {
    miti @(
        Common           : {
            //show text, not id for mitigation in the context of risks
            Text            : miti.description,
            TextArrangement : #TextOnly,
            ValueList       : {
                Label          : 'Mitigations',
                CollectionPath : 'Mitigations',
                Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : miti_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'description'
                }
                ]
            }
        },
        UI.MultiLineText : IsActiveEntity
    );
}