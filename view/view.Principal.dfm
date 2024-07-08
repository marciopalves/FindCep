object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Busca Cep'
  ClientHeight = 544
  ClientWidth = 787
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object pnlFiltro: TPanel
    Left = 0
    Top = 0
    Width = 787
    Height = 113
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 783
    object btnPesquisar: TButton
      Left = 697
      Top = 84
      Width = 83
      Height = 22
      Caption = '&Pesquisar'
      TabOrder = 1
      OnClick = btnPesquisarClick
    end
    object rbtnJson: TRadioButton
      Left = 588
      Top = 51
      Width = 72
      Height = 17
      Caption = 'JSON'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
    object rbtnXml: TRadioButton
      Left = 588
      Top = 90
      Width = 72
      Height = 17
      Caption = 'XML'
      TabOrder = 3
    end
    object gbFiltro: TGroupBox
      Left = 1
      Top = 1
      Width = 572
      Height = 111
      Align = alLeft
      Caption = 'Filtro'
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 13
        Width = 21
        Height = 15
        Caption = 'Cep'
      end
      object Label2: TLabel
        Left = 135
        Top = 13
        Width = 62
        Height = 15
        Caption = 'Logradouro'
      end
      object Label11: TLabel
        Left = 343
        Top = 13
        Width = 77
        Height = 15
        Caption = 'Complemento'
      end
      object Label5: TLabel
        Left = 343
        Top = 64
        Width = 14
        Height = 15
        Caption = 'UF'
      end
      object Label4: TLabel
        Left = 135
        Top = 64
        Width = 57
        Height = 15
        Caption = 'Localidade'
      end
      object Label3: TLabel
        Left = 16
        Top = 64
        Width = 31
        Height = 15
        Caption = 'Bairro'
      end
      object edtCep: TEdit
        Left = 16
        Top = 29
        Width = 113
        Height = 23
        NumbersOnly = True
        TabOrder = 0
      end
      object edtLogradouro: TEdit
        Left = 133
        Top = 29
        Width = 201
        Height = 23
        TabOrder = 1
      end
      object edtComplemento: TEdit
        Left = 341
        Top = 29
        Width = 162
        Height = 23
        TabOrder = 2
      end
      object edtUF: TEdit
        Left = 341
        Top = 82
        Width = 45
        Height = 23
        TabOrder = 5
      end
      object edtLocalidade: TEdit
        Left = 133
        Top = 82
        Width = 201
        Height = 23
        TabOrder = 4
      end
      object edtBairro: TEdit
        Left = 16
        Top = 82
        Width = 113
        Height = 23
        TabOrder = 3
      end
    end
  end
  object pnlBody: TPanel
    Left = 0
    Top = 113
    Width = 787
    Height = 431
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 783
    ExplicitHeight = 430
    object pgDados: TPageControl
      Left = 0
      Top = 0
      Width = 787
      Height = 431
      ActivePage = tsEdits
      Align = alClient
      TabOrder = 0
      object tsDados: TTabSheet
        Caption = 'tsDados'
        ImageIndex = 1
        object pnlMemo: TPanel
          Left = 569
          Top = 0
          Width = 210
          Height = 360
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitHeight = 401
          object mmObjeto: TMemo
            Left = 0
            Top = 0
            Width = 210
            Height = 360
            Align = alClient
            BevelOuter = bvNone
            Enabled = False
            TabOrder = 0
            ExplicitHeight = 401
          end
        end
        object pnlGrid: TPanel
          Left = 0
          Top = 0
          Width = 569
          Height = 360
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitHeight = 180
          object dbgEnderecos: TDBGrid
            Left = 0
            Top = 0
            Width = 569
            Height = 360
            Hint = 'Duplo Clique para Editar'
            Align = alClient
            DataSource = ds
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -12
            TitleFont.Name = 'Segoe UI'
            TitleFont.Style = []
            OnDblClick = dbgEnderecosDblClick
            Columns = <
              item
                Expanded = False
                FieldName = 'Cep'
                Width = 60
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'Logradouro'
                Width = 142
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'Complemento'
                Width = 95
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'Bairro'
                Width = 88
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'Localidade'
                Width = 142
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'UF'
                Width = 42
                Visible = True
              end>
          end
        end
        object pnlFooter: TPanel
          Left = 0
          Top = 360
          Width = 779
          Height = 41
          Align = alBottom
          BevelOuter = bvNone
          Caption = 
            #186'Duplo Clique na Grid  para Editar                '#186' ALT+D Para D' +
            'eletar'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          ExplicitLeft = 48
          ExplicitTop = 304
          ExplicitWidth = 185
        end
      end
      object tsEdits: TTabSheet
        Caption = 'Edi'#231#227'o'
        ImageIndex = 1
        object pnlEdits: TPanel
          Left = 0
          Top = 0
          Width = 779
          Height = 401
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 775
          ExplicitHeight = 400
          object Label6: TLabel
            Left = 31
            Top = 61
            Width = 21
            Height = 15
            Caption = 'Cep'
          end
          object Label7: TLabel
            Left = 150
            Top = 61
            Width = 62
            Height = 15
            Caption = 'Logradouro'
          end
          object Label8: TLabel
            Left = 199
            Top = 113
            Width = 31
            Height = 15
            Caption = 'Bairro'
          end
          object Label9: TLabel
            Left = 29
            Top = 172
            Width = 57
            Height = 15
            Caption = 'Localidade'
          end
          object Label10: TLabel
            Left = 236
            Top = 172
            Width = 14
            Height = 15
            Caption = 'UF'
          end
          object Label12: TLabel
            Left = 31
            Top = 113
            Width = 77
            Height = 15
            Caption = 'Complemento'
          end
          object edtEdicaoCep: TEdit
            Left = 29
            Top = 77
            Width = 113
            Height = 23
            NumbersOnly = True
            TabOrder = 0
          end
          object edtEdicaoLogradouro: TEdit
            Left = 148
            Top = 77
            Width = 201
            Height = 23
            TabOrder = 1
          end
          object edtEdicaoBairro: TEdit
            Left = 196
            Top = 134
            Width = 152
            Height = 23
            TabOrder = 3
          end
          object edtEdicaoLocalidade: TEdit
            Left = 29
            Top = 190
            Width = 201
            Height = 23
            TabOrder = 4
          end
          object edtEdicaoUF: TEdit
            Left = 235
            Top = 190
            Width = 45
            Height = 23
            TabOrder = 5
          end
          object pnlBotoesEdicao: TPanel
            Left = 1
            Top = 344
            Width = 777
            Height = 56
            Align = alBottom
            TabOrder = 6
            ExplicitTop = 343
            ExplicitWidth = 773
            object pnlEspacamentoTop: TPanel
              Left = 1
              Top = 1
              Width = 775
              Height = 8
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 2
              ExplicitWidth = 771
            end
            object pnlEspacamento: TPanel
              Left = 1
              Top = 9
              Width = 424
              Height = 39
              Align = alLeft
              BevelOuter = bvNone
              TabOrder = 0
            end
            object pnlCancelar: TPanel
              Left = 425
              Top = 9
              Width = 89
              Height = 39
              Align = alLeft
              TabOrder = 1
              object Shape: TShape
                Left = 1
                Top = 1
                Width = 87
                Height = 37
                Align = alClient
                Shape = stRoundRect
                ExplicitLeft = 32
                ExplicitTop = 8
                ExplicitWidth = 65
                ExplicitHeight = 65
              end
              object btnCancelar: TSpeedButton
                Left = 1
                Top = 1
                Width = 87
                Height = 37
                Align = alClient
                Caption = '&Cancelar'
                OnClick = btnCancelarClick
                ExplicitLeft = 72
                ExplicitTop = 16
                ExplicitWidth = 23
                ExplicitHeight = 22
              end
            end
            object pnlEspacamentoBotton: TPanel
              Left = 1
              Top = 48
              Width = 775
              Height = 7
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 3
              ExplicitWidth = 771
            end
            object pnlGravar: TPanel
              Left = 561
              Top = 9
              Width = 89
              Height = 39
              Align = alLeft
              TabOrder = 4
              object Shape1: TShape
                Left = 1
                Top = 1
                Width = 87
                Height = 37
                Align = alClient
                Shape = stRoundRect
                ExplicitLeft = 32
                ExplicitTop = 8
                ExplicitWidth = 65
                ExplicitHeight = 65
              end
              object btnGravar: TSpeedButton
                Left = 1
                Top = 1
                Width = 87
                Height = 37
                Align = alClient
                Caption = '&Gravar'
                OnClick = btnGravarClick
                ExplicitLeft = 72
                ExplicitTop = 16
                ExplicitWidth = 23
                ExplicitHeight = 22
              end
            end
            object pnlEspacamentoBotoes: TPanel
              Left = 514
              Top = 9
              Width = 47
              Height = 39
              Align = alLeft
              BevelOuter = bvNone
              TabOrder = 5
            end
          end
          object edtEdicaoComplemento: TEdit
            Left = 29
            Top = 134
            Width = 162
            Height = 23
            TabOrder = 2
          end
        end
      end
    end
  end
  object ds: TDataSource
    DataSet = mmTable
    Left = 628
    Top = 243
  end
  object mmTable: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 628
    Top = 177
    object mmTableID: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object mmTableCep: TStringField
      FieldName = 'Cep'
    end
    object mmTableComplemento: TStringField
      FieldName = 'Complemento'
    end
    object mmTableBairro: TStringField
      FieldName = 'Bairro'
    end
    object mmTableLocalidade: TStringField
      FieldName = 'Localidade'
    end
    object mmTableUF: TStringField
      FieldName = 'UF'
    end
    object mmTableLogradouro: TStringField
      FieldName = 'Logradouro'
      Size = 60
    end
  end
  object ActionList: TActionList
    Left = 636
    Top = 339
    object actPesquisar: TAction
      Caption = '&Pesquisar'
      ShortCut = 32848
      OnExecute = actPesquisarExecute
    end
    object actEditar: TAction
      Caption = '&Editar'
      ShortCut = 32837
      OnExecute = actEditarExecute
    end
    object actDeletar: TAction
      Caption = '&Deletar'
      ShortCut = 32836
      OnExecute = actDeletarExecute
    end
    object actCancelar: TAction
      Caption = '&Cancelar'
      ShortCut = 32835
      OnExecute = actCancelarExecute
    end
    object actSalvar: TAction
      Caption = '&Salvar'
      OnExecute = actSalvarExecute
    end
  end
end
