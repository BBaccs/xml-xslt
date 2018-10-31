<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:exslt="http://exslt.org/common"
        xmlns:func="http://exslt.org/functions"
        xmlns:str="http://exslt.org/strings"
        xmlns:date="http://exslt.org/dates-and-times"
        xmlns:olp="http://olp.edataserver.com"
        xmlns:php="http://php.net/xsl"
        xmlns:dyn="http://exslt.org/dynamic"
        exclude-result-prefixes="olp func exslt fn php"
        extension-element-prefixes="exslt func str date dyn">
<xsl:import href="@@path@@/xml/olp.misc.func.xml" />
<xsl:import href="@@path@@/xml/olp.date.func.xml" />
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
<xsl:template match="/">
<LeadDetails>
    <LeadTransactionInformation>
        <StoreName><xsl:value-of select="data/constant/store_name" /></StoreName>
        <MerchandiseName><xsl:value-of select="data/constant/merchandise_name" /></MerchandiseName>
        <CampaignName><xsl:value-of select="data/constant/campaign_name" /></CampaignName>
        <UserName><xsl:value-of select="data/constant/user_name" /></UserName>
        <Password><xsl:value-of select="data/constant/password" /></Password>
        <LeadDate><xsl:value-of select="olp:format-date('MM-dd-yyyy', data/constant/lead_date" /></LeadDate>
        <SubAffiliateId><xsl:value-of select="data/constant/sub_affiliate_id" /></SubAffiliateId>
        <ProductType><xsl:value-of select="data/constant/product_type" /></ProductType>
    </LeadTransactionInformation>
    <CustomerDeviceDetail>
        <IPAddress><xsl:value-of select="data/application/client_ip_address" /></IPAddress>
        <DeviceUniqueID><xsl:value-of select="data/constant/unique_id" /></DeviceUniqueID>
        <UserAgent><xsl:value-of select="data/application/client_user_agent" /></UserAgent>
    </CustomerDeviceDetail>
    <LoanInformation>
        <DateApplied><xsl:value-of select="data/constant/date_applied" /></DateApplied>
        <LoanAmount><xsl:value-of select="data/application/loan_amount_desired" /></LoanAmount>
        <RequestedEffectiveDate><xsl:value-of select="data/constant/requested_effective_date" /></RequestedEffectiveDate>
        <RequestedDueDate><xsl:value-of select="data/constant/requested_due_date" /></RequestedDueDate>
        <!-- IPAaddress shows up twice, remove one? Response - leave for now-->
        <IPAddress><xsl:value-of select="data/application/client_ip_address" /></IPAddress>
    </LoanInformation>
    <CustomerInformation>
        <PersonalInformation>
            <FirstName><xsl:value-of select="data/application/name_first" /></FirstName>
            <LastName><xsl:value-of select="data/application/name_last" /></LastName>
            <Suffix><xsl:value-of select="data/application/title" /></Suffix>
            <Address><xsl:value-of select="data/application/home_street" /></Address>
            <City><xsl:value-of select="data/application/home_city" /></City>
            <State><xsl:value-of select="data/application/home_state" /></State>
            <Zip><xsl:value-of select="data/application/home_zip" /></Zip>
            <HomeStatus><xsl:value-of select="data/constant/home_status" /></HomeStatus>
            <PrimaryPhone><xsl:value-of select="data/application/phone_home" /></PrimaryPhone>
            <HomePhone><xsl:value-of select="data/application/phone_home" /></HomePhone>
            <MobilePhone><xsl:value-of select="data/application/phone_cell" /></MobilePhone>
            <SSN><xsl:value-of select="data/application/social_security_number" /></SSN>
            <Email><xsl:value-of select="data/application/email_primary" /></Email>
            <DateOfBirth><xsl:value-of select="olp:format-date('MM-dd-yyyy', data/application/date_of_birth)" /></DateOfBirth>
            <DrivingLicenseState><xsl:value-of select="data/application/state_issued_id" /></DrivingLicenseState>
            <DrivingLicenseNumber><xsl:value-of select="data/application/state_id_number" /></DrivingLicenseNumber>
            <YearsAtCurrentAddress>
                <xsl:choose>
                    <xsl:when test="data/application/residence_length_months &lt; 12">0</xsl:when>
                    <xsl:otherwise><xsl:value-of select="floor(data/application/residence_length_months div 12)" /></xsl:otherwise>
                </xsl:choose>
            </YearsAtCurrentAddress>
            <MonthsAtCurrentAddress>
                <xsl:choose>
                    <xsl:when test="data/application/residence_length_months &lt; 12">
                        <xsl:value-of select="data/application/residence_length_months" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="data/application/residence_length_months mod 12" />
                    </xsl:otherwise>
                </xsl:choose>
            </MonthsAtCurrentAddress>
           <IsClaimedMilitary>
                <xsl:choose>
                    <xsl:when test="data/application/military = 'FALSE'">0</xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </IsClaimedMilitary>
            <IsEmailVerified><xsl:value-of select="data/application/is_email_verified" /></IsEmailVerified>
            <PreferredLanguage><xsl:value-of select="data/application/preferred_language" /></PreferredLanguage>     
        </PersonalInformation>
        <EmployerInformation>
            <IncomeType>
            <!-- How do we know potential values of income_type can be equal to, other than the current value in the source document? employment vs job. Response: for now ask Ryan C -->
             <xsl:choose>
                    <xsl:when test="data/application/income_type = 'EMPLOYMENT'">P</xsl:when>
                    <xsl:when test="data/application/income_type = 'BENEFITS'">S</xsl:when>
                    <xsl:otherwise>O</xsl:otherwise>
                </xsl:choose>
            </IncomeType>
            <EmployerName><xsl:value-of select="data/application/employer_name" /></EmployerName>
            <Address><xsl:value-of select="data/application/employer_street" /></Address>
            <City><xsl:value-of select="data/application/employer_city" /></City>
            <State><xsl:value-of select="data/application/employer_state" /></State>
            <Zip><xsl:value-of select="data/application/employer_zip" /></Zip>
            <Phone><xsl:value-of select="data/constant/employer_phone" /></Phone>
            <PhoneExtn><xsl:value-of select="data/application/ext_work" /></PhoneExtn>
            <!-- <Phone></Phone> brick and mortar path? Response: we don't really do brick and mortar anymore
            <Fax />  brick and mortar? -->
            <PointOfContact><xsl:value-of select="data/constant/point_of_contact" /></PointOfContact>
            <JobTitle><xsl:value-of select="data/constant/job_title" /></JobTitle>
            <JobType><xsl:value-of select="data/constant/job_type" /></JobType>
            <AverageSalary><xsl:value-of select="data/application/income_monthly_net * 12" /></AverageSalary>
            <!--this normally would be a choose statement given that they require specific values, however we don't have this node, so is making a value-of constant correct?-->
            <PayRollType> 
                <xsl:choose>
                    <xsl:when test="data/application/income_frequency = 'TRUE'">D</xsl:when>
                    <xsl:otherwise>P</xsl:otherwise>
                </xsl:choose>
            </PayRollType>
            <!-- Periodicity and Frequency are the same and both required, so I duplicated it. Is this okay? -->
            <Periodicity>
                <xsl:choose>
                    <xsl:when test="data/application/income_frequency = 'WEEKLY'">W</xsl:when>
                    <xsl:when test="data/application/income_frequency = 'BI_WEEKLY'">B</xsl:when>
                    <xsl:when test="data/application/income_frequency = 'TWICE_MONTHLY'">S</xsl:when>
                    <xsl:otherwise>M</xsl:otherwise>
                </xsl:choose>
            </Periodicity>
            <Frequency>
                <xsl:choose>
                    <xsl:when test="data/application/income_frequency = 'WEEKLY'">W</xsl:when>
                    <xsl:when test="data/application/income_frequency = 'BI_WEEKLY'">B</xsl:when>
                    <xsl:when test="data/application/income_frequency = 'TWICE_MONTHLY'">S</xsl:when>
                    <xsl:otherwise>M</xsl:otherwise>
                </xsl:choose>
            </Frequency>
            <LastPayDate><xsl:value-of select="olp:format-date('MM-dd-yyyy', data/application/last_pay_date)" /></LastPayDate>
            <NextPayDate><xsl:value-of select="olp:format-date('MM-dd-yyyy', data/application/next_pay_date)" /></NextPayDate>
            <SecondPayDate><xsl:value-of select="olp:format-date('MM-dd-yyyy', data/application/paydate2)" /></SecondPayDate>
            <IsPrimary><xsl:value-of select="data/constant/is_primary" /></IsPrimary>
        </EmployerInformation>
        <BankInformation>
        <!-- No format specificied so I believe this is good.-->
            <BankName><xsl:value-of select="data/application/bank_name" /></BankName>
            <ABANumber><xsl:value-of select="data/application/bank_aba" /></ABANumber>
            <AccountNumber><xsl:value-of select="data/application/bank_account" /></AccountNumber>
            <AccountType><xsl:value-of select="data/application/bank_account_type" /></AccountType>
        </BankInformation>
        <AutoTitle>
            <VehicleModel><xsl:value-of select="data/constant/vehicle_model" /></VehicleModel>
            <VehicleNumber><xsl:value-of select="data/constant/vehicle_number" /></VehicleNumber>
            <VIN><xsl:value-of select="data/constant/vin" /></VIN>
            <ChassisNumber><xsl:value-of select="data/constant/chassis_number" /></ChassisNumber>
            <InsuranceNumber><xsl:value-of select="data/constant/insurance_number" /></InsuranceNumber>
            <Mileage><xsl:value-of select="data/constant/mileage" /></Mileage>
        </AutoTitle>
    </CustomerInformation>
</LeadDetails>
</xsl:template>
</xsl:stylesheet>