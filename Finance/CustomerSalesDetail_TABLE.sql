USE [GartmanReport]
GO

/****** Object:  Table [dbo].[CustomerSalesDetail]    Script Date: 10/14/2014 10:32:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE dbo.CustomerSalesDetail
GO

CREATE TABLE [dbo].[CustomerSalesDetail](
	[InvoiceNbr] [nvarchar](20) NULL,
	[InvoiceDate] [nvarchar](20) NULL,
	[CreditMemo] [nvarchar](5) NULL,
	[CustPO] [nvarchar](40) NULL,
	[Company] [nvarchar](3) NULL,
	[Loc] [nvarchar](2) NULL,
	[OrderNbr] [nvarchar](20) NULL,
	[SalesID] [nvarchar](20) NULL,
	[SalesName] [nvarchar](40) NULL,
	[BillToCustID] [nvarchar](20) NULL,
	[BillToCustName] [nvarchar](40) NULL,
	[BillToCity] [nvarchar](40) NULL,
	[BillToState] [nvarchar](20) NULL,
	[SoldToCustID] [nvarchar](20) NULL,
	[SoldToCustName] [nvarchar](40) NULL,
	[SoldToCity] [nvarchar](40) NULL,
	[SoldToState] [nvarchar](20) NULL,
	[ShipToCustName] [nvarchar](40) NULL,
	[ShipToCity] [nvarchar](40) NULL,
	[ShipToState] [nvarchar](20) NULL,
	[ShipToZip] [nvarchar](20) NULL,
	[ItemNum] [nvarchar](40) NULL,
	[ItemDesc] [nvarchar](55) NULL,
	[VendorNum] [nvarchar](16) NULL,
	[VendorName] [nvarchar](40) NULL,
	[ProductCode] [nvarchar](22) NULL,
	[ProductCodeDesc] [nvarchar](40) NULL,
	[FamilyCode] [nvarchar](15) NULL,
	[FamilyCodeDesc] [nvarchar](40) NULL,
	[ClassCode] [nvarchar](22) NULL,
	[ClassCodeDesc] [nvarchar](40) NULL,
	[Division] [nvarchar](22) NULL,
	[DivisionDesc] [nvarchar](40) NULL,
	[ExtendedPrice] [decimal](18, 5) NULL,
	[ExtendedCost] [decimal](18, 5) NULL,
	[Profit] [decimal](18, 5) NULL
) ON [PRIMARY]

GO


