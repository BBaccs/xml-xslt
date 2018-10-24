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

<!-- Do we need LeadDetails node? yes -->
<LeadDetails>
<!-- end comment -->

    <LeadTransactionInformation>
        <StoreName><xsl:value-of select="data/constant/store_name" /></StoreName>
        <CampaignName><xsl:value-of select="data/constant/campaign_name" /></CampaignName>
        <!-- No matching nodes in BH Source Doc, make constant? -->
        <UserName><xsl:value-of select="data/constant/user_name" /></UserName>
        <Password><xsl:value-of select="data/constant/password" /></Password>
        <LeadDate><xsl:value-of select="data/constant/lead_date" /></LeadDate>
        <!--  end  comment-->
    </LeadTransactionInformation>

    <CustomerDeviceDetail>
        <IPAddress><xsl:value-of select="data/application/client_ip_address" /></IPAddress>
        <!-- always add informaiton we have AKA UserAgent regardless if it's mandatory-->
    </CustomerDeviceDetail>

    <LoanInformation>
        <LoanAmount><xsl:value-of select="data/application/loan_amount_desired" /></LoanAmount>
    </LoanInformation>

    <CustomerInformation>
        <PersonalInformation>
            <FirstName><xsl:value-of select="data/application/name_first" /></FirstName>
            <LastName><xsl:value-of select="data/application/name_last" /></LastName>
            <Address><xsl:value-of select="data/application/home_street" /></Address>
            <City><xsl:value-of select="data/application/home_city" /></City>
            <State><xsl:value-of select="data/application/home_state" /></State>
            <Zip><xsl:value-of select="data/application/home_zip" /></Zip>
            <Email><xsl:value-of select="data/application/email_primary" /></Email>
            <DateOfBirth><xsl:value-of select="olp:format('MM-dd-yyyy', data/application/date_of_birth)" /></DateOfBirth>
            <DrivingLicenseState><xsl:value-of select="data/application/state_issued_id" /></DrivingLicenseState>
            <DrivingLicenseNumber><xsl:value-of select="data/application/state_id_number" /></DrivingLicenseNumber>
           <IsClaimedMilitary>
                <xsl:choose>
                    <xsl:when test="data/application/military = 'FALSE'">0</xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </IsClaimedMilitary>

            <!-- This is a self closing tag in the desired outcome xml file, should it be here? Constant? -->
            <PrimaryPhone><xsl:value-of select="data/application/phone_home" /></PrimaryPhone>
            <!-- end comment -->
            <HomePhone><xsl:value-of select="data/application/phone_home" /></HomePhone>

            <!-- Years and months both required by lender but only month node in source doc, do we need to multiply by 12, if so, how, or insert a constant? -->
            <!-- <YearsAtCurrentAddress><xsl:value-of select="data/application/residence_length_months" /></YearsAtCurrentAddress>
            <MonthsAtCurrentAddress><xsl:value-of select="data/application/residence_length_months" /></MonthsAtCurrentAddress> -->
            <!-- end comment -->

            <!-- Logic required  
            They're asking total time 1year 3months NOT 1.25years and 15 months.
            *Use a modalist operation to get the right value. see below.
            -->
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
            <YearsAtCurrentAddress>
                <xsl:choose>
                    <xsl:when test="data/application/residence_length_months &lt; 12">0</xsl:when>
                    <xsl:otherwise><xsl:value-of select="floor(data/application/residence_length_months div 12)" /></xsl:otherwise>
                </xsl:choose>
            </YearsAtCurrentAddress>

            <SSN><xsl:value-of select="data/application/social_security_number" /></SSN>


            <!--Lender excepts two values, 0 & 1. Source document contains T/F. Is this cause for a choose/when statement? Are choose/whens always used when the lender desires a specific value that differs from ours? -->
            
            <!--Lender excepts two values, 0 & 1. Source document contains T/F. Is this cause for a choose/when statement? -->

        </PersonalInformation>

        <EmployerInformation>
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
   
   
   <!-- changed date format 9/11/2018 -->
            <SecondPayDate><xsl:value-of select="olp:format-date('MM-dd-yyyy', data/application/paydate2)" /></SecondPayDate>
            <AverageSalary><xsl:value-of select="data/application/income_monthly_net * 12" /></AverageSalary>
            <!-- <SecondPayDate><xsl:value-of select="data/constant/second_pay_date_constant" /></SecondPayDate> -->
        </EmployerInformation>

        <!-- need to format
        <BankInformation>
            <BankName><xsl:value-of select="data/application/bank_name" /></BankName>
            <ABANumber><xsl:value-of select="data/application/bank_aba" /></ABANumber>
            <AccountNumber><xsl:value-of select="data/application/bank_account" /></AccountNumber>
            <AccountType><xsl:value-of select="data/application/bank_account_type" /></AccountType>
        </BankInformation> -->
    </CustomerInformation>

</LeadDetails>
</xsl:template>
</xsl:stylesheet>