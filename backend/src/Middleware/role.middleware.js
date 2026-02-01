const requireSuperAdmin = (req, res, next) => {
  if (req.user.role !== "SUPER_ADMIN") {
    return res.status(403).json({
      success: false,
      message: "Super admin access only",
    });
  }
  next();
};

const requireAdmin = (req, res, next) => {
  if (req.user.role !== "SUPER_ADMIN" && req.user.role !== "MINE_ADMIN") {
    return res.status(403).json({
      success: false,
      message: "Admin access only",
    });
  }
  next();
};

export { requireSuperAdmin, requireAdmin };
