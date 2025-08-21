{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    lazysql
  ];

  xdg.configFile."lazysql/config.yml".text = ''
    theme:
      activeBorderColor:
        - "#8aadf4"
        - "bold"
      inactiveBorderColor:
        - "#a5adcb"
      optionsTextColor:
        - "#8aadf4"
      selectedLineBgColor:
        - "#363a4f"
      selectedRowBgColor:
        - "#363a4f"
      primaryTextColor:
        - "#cad3f5"
      secondaryTextColor:
        - "#a5adcb"
      successTextColor:
        - "#a6da95"
      errorTextColor:
        - "#ed8796"
      warningTextColor:
        - "#eed49f"
      searchingActiveBorderColor:
        - "#eed49f"
      tableHeaderColor:
        - "#8aadf4"
      keyColor:
        - "#f4dbd6"
      valueColor:
        - "#cad3f5"
  '';
}