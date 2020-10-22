/**
 * Implementation for Risk Management service defined in ./risk-service.cds
 */
module.exports = async (srv) => {
    const messaging = await cds.connect.to('messaging');
     const bupaSrv = await cds.connect.to("API_BUSINESS_PARTNER"),
     { A_BusinessPartner: userInfo } = bupaSrv.entities,
     {BusinessPartners} = srv.entities
     srv.after('READ', 'Risks', (risks) => {
 
         risks.forEach((risk) => {
             if (risk.impact >= 100000) {
                 risk.criticality = 1;
             } else {
                 risk.criticality = 2;
             }
         });
     });
 
     messaging.on("refapps/cpappems/abc/BO/BusinessPartner/Created", async msg => {
         console.log("<< event caught", msg);
         const BUSINESSPARTNER = (+(msg.data.KEY[0].BUSINESSPARTNER)).toString();
         const {BusinessPartners, API_BusinessPartner} = srv.entities;
         const bpEntity = await bupaSrv.tx(msg).run(SELECT.one(API_BusinessPartner).where({BusinessPartner: BUSINESSPARTNER}));
         const result = await cds.tx(msg).run(INSERT.into(BusinessPartners).entries({BusinessPartnerID:BUSINESSPARTNER, Status:'Not Assessed', FirstName:bpEntity.FirstName, LastName:bpEntity.LastName}));
         console.log("bp inserted");
     });
 
     srv.on('READ', srv.entities.API_BusinessPartner, async (req) => {
         const res = await bupaSrv.tx(req).run(req.query)
         return res;
     });
 
     srv.before("UPDATE", BusinessPartners, (req)=> {
         if(req.data.risks) {
             req.data.Status = "Assessed";
         }
     });
 }