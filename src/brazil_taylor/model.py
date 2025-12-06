import pandas as pd
import numpy as np

class TaylorRuleModel:
    """Stub de classe para estimar regra de Taylor e verificar determinacy.
    Expanda com métodos de carregamento de dados, estimação e testes."""

    def __init__(self, data: pd.DataFrame):
        self.data = data

    def estimate_stub(self):
        """Método placeholder para futura estimação.
        Retorna dicionário com coeficientes fictícios."""
        return {"phi_pi": 1.5, "phi_y": 0.5}

    def determinacy_condition(self, kappa: float = 0.1, beta: float = 0.99):
        params = self.estimate_stub()
        lhs = kappa * (params["phi_pi"] - 1) + (1 - beta) * params["phi_y"]
        return lhs > 0, lhs
